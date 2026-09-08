[CmdletBinding()]
param([Parameter(Mandatory)][string]$InputPath)

# Stateless audit of a coordinator's bounded assignment packet. This neither
# schedules workers nor records acceptance; all decisions come from frozen files.
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Swe-ArtifactFields.ps1')
$fieldContract = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot '../references/eligibility-fields.json') | ConvertFrom-Json
$packet = Get-Content -Raw -LiteralPath $InputPath | ConvertFrom-Json
$reasons = [Collections.Generic.List[string]]::new()
$allowAgentApproval = $false
function Field($Object, [string]$Name, $Default = $null) {
    if ($null -ne $Object -and $null -ne $Object.PSObject.Properties[$Name]) { return $Object.$Name }
    return $Default
}
function Require-Fields($Object, [string[]]$Names, [string]$Context) {
    foreach ($name in $Names) {
        # Inspect the property itself: pipeline enumeration turns a valid empty
        # dependency/pending array into no output, which is not a missing field.
        if ($null -eq $Object -or $null -eq $Object.PSObject.Properties[$name] -or $null -eq $Object.$name) { throw "Missing $Context.$name" }
    }
}
function Read-Frozen($Locator) {
    Require-Fields $Locator @('repository','path','artifact_id','sha256') 'locator'
    return (Get-SweArtifactLocator $Locator $Locator.repository).text
}
function Test-Decision($Locator, [switch]$Human) {
    $text = Read-Frozen $Locator
    $header = [regex]::Match($text, '(?ms)\A---\s*\r?\n(?<body>.*?)\r?\n---').Groups['body'].Value
    if ($header -notmatch '(?m)^status:\s*"?(Accepted|Target|Implemented|Current)"?\s*$') { throw "Prerequisite is not approved: $($Locator.artifact_id)" }
    $author = [regex]::Match($text, '(?m)^\|\s*Author\s*\|\s*([^|]+)\|').Groups[1].Value.Trim()
    $approver = [regex]::Match($text, '(?m)^\|\s*Approver\s*\|\s*([^|]+)\|').Groups[1].Value.Trim()
    if (-not $author -or -not $approver -or $author -eq $approver -or $text -notmatch '(?m)^\|\s*Decision\s*\|\s*Accepted\s*\|') { throw "Independent accepted decision unavailable: $($Locator.artifact_id)" }
    $humanRecord = $text -match '(?im)^\|\s*(Approver kind|Mode)\s*\|\s*Human\s*\|'
    $agentPermitted = $allowAgentApproval -and $Locator.repository -eq $packet.repository
    if (-not $Human -and -not $humanRecord -and -not $agentPermitted) {
        foreach ($sourcePolicy in @(Field $packet 'approval_policies' @())) {
            $sourcePolicyText = Read-Frozen $sourcePolicy
            $sourceScope = '(?m)^adoption_repository:\s*"?' + [regex]::Escape($Locator.repository) + '"?\s*$'
            if ($sourcePolicyText -match $sourceScope) {
                Test-Decision $sourcePolicy -Human
                if ($sourcePolicyText -match '(?m)^approval_policy:\s*"?risk-based"?\s*$' -and $sourcePolicyText -match '(?m)^owner_authorized:\s*true\s*$') { $agentPermitted = $true }
            }
        }
    }
    if (($Human -or -not $agentPermitted) -and -not $humanRecord) { throw 'Human approval is required without an applicable owner-adopted policy for the decision repository or for a major decision.' }
    if (-not $humanRecord -and $text -notmatch '(?im)^\|\s*Mode\s*\|\s*auto-approve\s*\|') { throw 'Agent approval must identify its actual auto-approve mode.' }
    $named = Field (Field $packet 'named_approvers') $Locator.artifact_id
    if ($named -and $approver -cne $named) { throw 'The explicitly named approver was not preserved.' }
}
function Test-Behavior($Behavior, [string[]]$Criteria) {
    Require-Fields $Behavior @('validation','receipt','receipt_sha256','generation') 'behavior'
    Test-Decision $Behavior.validation
    $validationText = Read-Frozen $Behavior.validation
    if ($validationText -notmatch [regex]::Escape($Behavior.receipt)) { throw 'Validation does not identify the supplied execution receipt.' }
    if ((Get-FileHash -LiteralPath $Behavior.receipt -Algorithm SHA256).Hash -ne $Behavior.receipt_sha256 -or $validationText -notmatch [regex]::Escape($Behavior.receipt_sha256)) { throw 'Receipt differs from the immutable bytes reviewed by Validation.' }
    $receipt = Get-Content -Raw -LiteralPath $Behavior.receipt | ConvertFrom-Json
    if ($receipt.schema -ne 'swe-check-receipt/v1' -or $receipt.outcome -ne 'Passed' -or -not $receipt.reusable -or $receipt.changed_during_run -or $receipt.before.digest -ne $Behavior.generation -or $receipt.after.digest -ne $Behavior.generation -or @($receipt.missing_coverage).Count -gt 0) { throw 'Behavior evidence is pending, failed, blocked, stale, or incomplete.' }
    if ($null -eq $Criteria -or $Criteria.Count -eq 0) { throw 'Consumed behavior criteria are unknown.' }
    foreach ($criterion in $Criteria) {
        if ($validationText -notmatch [regex]::Escape($criterion) -or @($receipt.attempts | Where-Object { $_.outcome -eq 'Passed' -and $criterion -cin @($_.criteria) }).Count -eq 0) { throw "Consumed criterion lacks accepted attributable evidence: $criterion" }
    }
    foreach ($attempt in @($receipt.attempts)) {
        foreach ($resource in @($attempt.stdout, $attempt.stderr, (Field $attempt 'observation'))) {
            if ($null -ne $resource -and (Get-FileHash -LiteralPath $resource.path -Algorithm SHA256).Hash -ne $resource.digest) { throw 'Reviewed execution logs or native observations changed.' }
        }
    }
    Require-Fields $receipt.request @('path','digest') 'receipt.request'
    if ((Get-FileHash -LiteralPath $receipt.request.path -Algorithm SHA256).Hash -ne $receipt.request.digest) { throw 'Immutable execution request changed.' }
    $current = (& (Join-Path $PSScriptRoot 'Invoke-SweChecks.ps1') -RequestPath $receipt.request.path -FingerprintOnly) | ConvertFrom-Json
    if ($current.digest -ne $Behavior.generation) { throw 'Behavior source, added files, runtime, environment, or dependency closure changed after execution.' }
}
$deferral = $false
$eligible = $false
try {
    Require-Fields $packet $fieldContract.required 'assignment'
    if ($packet.schema -ne $fieldContract.packet_schema -or -not $packet.assignment_id -or -not [IO.Path]::IsPathRooted($packet.repository) -or -not (Test-Path -LiteralPath $packet.repository -PathType Container)) { throw 'Unsupported schema or missing exact assignment/repository identity.' }
    if ($packet.phase -notin $fieldContract.phases) { throw 'Unknown entry phase.' }
    Require-Fields $packet $fieldContract.phase_required.($packet.phase) 'assignment'
    $policy = Field $packet 'policy_adoption' (Field $packet 'run_authorization')
    if ($null -ne $policy) {
        Test-Decision $policy -Human
        $policyText = Read-Frozen $policy
        $scopePattern = '(?m)^adoption_repository:\s*"?' + [regex]::Escape($packet.repository) + '"?\s*$'
        if ($policyText -notmatch $scopePattern -or $policyText -notmatch '(?m)^approval_policy:\s*"?risk-based"?\s*$' -or $policyText -notmatch '(?m)^owner_authorized:\s*true\s*$') { throw 'Standing policy must record owner authorization and this exact repository scope.' }
        $allowAgentApproval = $true
    }
    if (Field $packet 'findings_source') { Test-Decision $packet.findings_source }
    Require-Fields $packet.review $fieldContract.review_required 'review'
    $cycleText = Read-Frozen $packet.review.cycle_history
    $recordedCycles = [regex]::Match($cycleText, '(?m)^consumed_cycles:\s*(\d+)\s*$')
    if (-not $recordedCycles.Success -or [int]$recordedCycles.Groups[1].Value -ne $packet.review.consumed_cycles) { throw 'Repair count differs from durable history; resume cannot reset cycles.' }
    $unresolved = [regex]::Match($cycleText, '(?m)^unresolved:\s*(true|false)\s*$')
    if (-not $unresolved.Success) { throw 'Durable cycle history must identify whether the decision remains unresolved.' }
    if ($packet.review.consumed_cycles -lt 0) { throw 'Invalid repair cycle count.' }
    if ($packet.review.consumed_cycles -ge 2 -and $unresolved.Groups[1].Value -eq 'true') {
        if ($null -eq (Field $packet.review 'human_disposition')) { throw 'Two repair cycles exhausted; explicit human disposition required.' }
        Test-Decision $packet.review.human_disposition -Human
    }
    foreach ($name in @('feature','plan','architecture')) { Test-Decision $packet.$name }
    if ($packet.phase -ne 'Design') { Test-Decision (Field $packet 'design') }
    Require-Fields $packet.risk (@('class','rationale') + @($fieldContract.risk_flags)) 'risk'
    if ($packet.risk.class -notin @('Minimal','Standard','Major') -or -not $packet.risk.rationale) { throw 'Risk is unresolved.' }
    foreach ($flag in $fieldContract.risk_flags) { if ($packet.risk.$flag -isnot [bool]) { throw "Risk flag $flag must be boolean." } }
    $major = $packet.risk.class -eq 'Major'
    foreach ($flag in @('public_contract','cross_solution','security','persistence','concurrency','operational')) {
        if ($packet.risk.$flag -isnot [bool]) { throw "Risk flag $flag must be boolean." }
        if ($packet.risk.$flag) { $major = $true }
    }
    if ($major) { Test-Decision (Field $packet 'major_approval') -Human }
    if (@($packet.dependencies).Count -eq 0 -and $packet.reviewed_independence -ne $true) { throw 'Missing reviewed independence finding.' }
    foreach ($dependency in @($packet.dependencies)) {
        Require-Fields $dependency @('assignment_id','requirement','entry_phase','criteria','cycle_free') 'dependency'
        if (-not $dependency.assignment_id -or $dependency.assignment_id -eq $packet.assignment_id -or $dependency.cycle_free -ne $true -or @($dependency.criteria).Count -eq 0) { throw 'Unknown, cyclic, or unattributed prerequisite.' }
        if ($dependency.entry_phase -notin @('Design','Implementation') -or $dependency.requirement -notin @('ApprovedContractOrDesign','ValidatedBehavior')) { throw 'Unknown prerequisite requirement.' }
        if ($dependency.entry_phase -eq 'Implementation' -and $packet.phase -eq 'Design') { continue }
        if ($dependency.requirement -eq 'ApprovedContractOrDesign') { Test-Decision $dependency.artifact }
        else { Test-Behavior $dependency.behavior $dependency.criteria }
    }
    $deferral = $packet.risk.class -eq 'Minimal' -and -not $major -and $packet.risk.isolated -eq $true -and $packet.risk.reversible -eq $true -and $packet.risk.reviewed_deferral -eq $true -and -not $packet.risk.mandatory_early_checks -and @($packet.behavior_consumers).Count -eq 0
    if ($deferral) {
        if ($null -eq $policy -or -not (Field $packet 'epic_id')) { $deferral = $false }
        else { Test-Decision $policy -Human }
    }
    if ($packet.phase -in @('FeatureCompletion','EpicAcceptance')) {
        if ((Field $packet 'implementation_complete') -ne $true) { throw 'Implementation obligations are incomplete.' }
        # Delivery completion is always independently verified, even when an
        # implementation milestone was allowed to carry deferred checks.
        if (@(Field $packet 'pending_checks' @('unknown')).Count -gt 0) { throw 'Required checks remain pending.' }
        Test-Behavior (Field $packet 'delivery') (Field $packet 'criteria' @())
        if ($packet.phase -eq 'EpicAcceptance') {
            Require-Fields $packet @('assignments_complete','architecture_reconciled','portfolio_validation') 'epic'
            if ($packet.assignments_complete -ne $true -or $packet.architecture_reconciled -ne $true) { throw 'Epic obligations or architecture reconciliation are incomplete.' }
            Test-Decision $packet.portfolio_validation
        }
    }
    $eligible = $true
} catch { $reasons.Add($_.Exception.Message); $deferral = $false }
[pscustomobject]@{ schema = 'swe-eligibility-result/v1'; assignment_id = (Field $packet 'assignment_id'); phase = (Field $packet 'phase'); eligible = $eligible; deferral_eligible = $deferral; reasons = @($reasons); grants_acceptance = $false }
