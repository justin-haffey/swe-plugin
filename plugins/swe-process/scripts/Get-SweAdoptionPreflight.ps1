[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Destination,
    [Parameter(Mandatory)][ValidateSet('portfolio','solution')][string]$Kind,
    [string]$Baseline,
    [string[]]$PackageRoots,
    [string]$PolicyPath,
    [string]$HostEvidencePath,
    [switch]$IncludeContent
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Swe-ArtifactFields.ps1')
$pluginRoot = Split-Path -Parent $PSScriptRoot
$expected = (Get-Content -Raw -LiteralPath (Join-Path $pluginRoot '.codex-plugin/plugin.json') | ConvertFrom-Json).version
$root = (Resolve-Path -LiteralPath $Destination).Path.TrimEnd('\','/')
$issues = [Collections.Generic.List[string]]::new()
$observations = [Collections.Generic.List[object]]::new()
$packageNames = @('swa-analyze','swe-codex','swe-process','swe-utility')
if (-not $PackageRoots) { $PackageRoots = @($packageNames | ForEach-Object { Join-Path (Split-Path -Parent $pluginRoot) $_ }) }
$seen = @{}
foreach ($packageRoot in $PackageRoots) {
    try {
        $manifestPath = Resolve-SweLocalFile $packageRoot '.codex-plugin/plugin.json'
        $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
        if ($seen.ContainsKey($manifest.name) -or $manifest.name -notin $packageNames) { throw 'Unknown or duplicate package identity.' }
        $seen[$manifest.name] = $true
        $observations.Add([pscustomobject]@{ package = $manifest.name; version = $manifest.version; manifest = $manifestPath; sha256 = (Get-FileHash -LiteralPath $manifestPath).Hash })
        if ($manifest.version -ne $expected -or -not $manifest.interface.displayName.EndsWith(" $expected")) { $issues.Add("Version mismatch: $($manifest.name), expected $expected.") }
    } catch { $issues.Add("Package ${packageRoot}: $($_.Exception.Message)") }
}
foreach ($name in $packageNames) { if (-not $seen.ContainsKey($name)) { $issues.Add("Package unavailable: $name") } }
$proposal = & (Join-Path $PSScriptRoot 'Get-SweMigrationDiff.ps1') -Destination $root -Baseline $Baseline -Proposed (Join-Path $pluginRoot "skills/swe-scaffold/references/$Kind") -IncludeContent:$IncludeContent
foreach ($change in $proposal.Changes) {
    if ($change.Action -eq 'ResolveOwnership') { $issues.Add("Migration requires resolution: $($change.Path) [$($change.Classification)]") }
}
$configPath = $null; $rolePath = $null; $skillPath = $null; $governancePath = $null
try {
    $configPath = Resolve-SweLocalFile $root '.codex/config.toml'
    $configText = Get-Content -Raw -LiteralPath $configPath
    $sections = [regex]::Matches($configText, '(?ms)^\[agents\.test_runner\]\s*\r?\n(.*?)(?=^\[|\z)')
    if ($sections.Count -ne 1) { throw 'One agents.test_runner registration is required.' }
    $registration = [regex]::Matches($sections[0].Groups[1].Value, '(?m)^config_file\s*=\s*"([^"]+)"\s*$')
    if ($registration.Count -ne 1) { throw 'Tester config_file is unresolved; use the host TOML resolver for other syntax.' }
    $rolePath = Resolve-SweLocalFile (Join-Path $root '.codex') $registration[0].Groups[1].Value
    $roleText = Get-Content -Raw -LiteralPath $rolePath
    foreach ($setting in @(@('name','test-runner'), @('model','gpt-5.6-luna'), @('model_reasoning_effort','medium'))) {
        $matches = [regex]::Matches($roleText, ('(?m)^' + $setting[0] + '\s*=\s*"([^"\r\n]+)"\s*$'))
        if ($matches.Count -ne 1 -or $matches[0].Groups[1].Value -cne $setting[1]) { throw "Tester setting mismatch: $($setting[0])" }
    }
    $skillPath = Resolve-SweLocalFile $pluginRoot 'skills/swe-test/SKILL.md'
    $governancePath = Resolve-SweLocalFile $root 'AGENTS.md'
} catch { $issues.Add("Static routing: $($_.Exception.Message)") }
$policyStatus = 'ReviewRequired'
try {
    if (-not $PolicyPath) { throw 'A reviewed compatibility/adoption decision is required; no policy is activated by preflight.' }
    $policy = Get-SweArtifactLocator ([pscustomobject]@{ path = $PolicyPath }) $root
    $policyText = $policy.text
    $policyHeader = [regex]::Match($policyText, '(?ms)\A---\s*\r?\n(?<body>.*?)\r?\n---').Groups['body'].Value
    if ($policyHeader -notmatch '(?m)^status:\s*"?Accepted"?\s*$') { throw 'Compatibility decision is not Accepted.' }
    foreach ($pattern in @('(?m)^\|\s*Decision\s*\|\s*Accepted\s*\|', '(?im)^\|\s*(Mode|Approver kind)\s*\|\s*human\s*\|', ('(?m)^adoption_repository:\s*"?' + [regex]::Escape($root) + '"?\s*$'), ('(?m)^target_version:\s*"?' + [regex]::Escape($expected) + '"?\s*$'))) {
        if ($policyText -notmatch $pattern) { throw 'Owner review must identify accepted human decision, exact destination and target version.' }
    }
    $author = [regex]::Match($policyText, '(?m)^\|\s*Author\s*\|\s*([^|]+)\|').Groups[1].Value.Trim()
    $approver = [regex]::Match($policyText, '(?m)^\|\s*Approver\s*\|\s*([^|]+)\|').Groups[1].Value.Trim()
    if (-not $author -or -not $approver -or $author -eq $approver) { throw 'Independent owner review is unresolved.' }
    $govHash = (Get-FileHash -LiteralPath $governancePath).Hash
    if ($policyText -notmatch ('(?m)^governance_sha256:\s*"?' + $govHash + '"?\s*$') -or $policyText -notmatch '(?m)^compatibility:\s*"?Compatible"?\s*$') { throw 'Policy review must bind the current governance bytes and explicitly record compatibility.' }
    $policyStatus = 'ReviewedCompatible'
} catch { $issues.Add("Policy compatibility: $($_.Exception.Message)") }
$hostStatus = 'Unverified'
try {
    if (-not $HostEvidencePath) { throw 'Actual host dispatch and a current real smoke receipt are required.' }
    $hostRecord = Get-Content -Raw -LiteralPath $HostEvidencePath | ConvertFrom-Json
    if ($hostRecord.schema -ne 'swe-host-preflight/v1' -or $hostRecord.repository -ne $root -or $hostRecord.model -cne 'gpt-5.6-luna' -or $hostRecord.reasoning_effort -cne 'medium' -or $hostRecord.role -cne 'test-runner' -or -not $hostRecord.session_id -or $hostRecord.route -notin @('NativeRole','ConfiguredFallback')) { throw 'Host identity, repository or exact tester route is invalid.' }
    foreach ($item in @(@('config',$configPath), @('role',$rolePath), @('skill',$skillPath))) {
        $bound = Get-SweField $hostRecord ($item[0] + '_file')
        if (-not $bound -or $bound.path -ne $item[1] -or (Get-FileHash -LiteralPath $item[1]).Hash -ne $bound.sha256) { throw "Host attestation does not bind current $($item[0]) bytes." }
    }
    foreach ($resource in @($hostRecord.dispatch_evidence, $hostRecord.receipt)) {
        if (-not $resource.path -or (Get-FileHash -LiteralPath $resource.path).Hash -ne $resource.sha256) { throw 'Missing or changed host dispatch evidence/receipt.' }
    }
    $receipt = Get-Content -Raw -LiteralPath $hostRecord.receipt.path | ConvertFrom-Json
    if ($receipt.schema -ne 'swe-check-receipt/v1' -or $receipt.outcome -ne 'Passed' -or -not $receipt.reusable -or $receipt.changed_during_run -or @($receipt.missing_coverage).Count -gt 0 -or $receipt.executor.session_id -cne $hostRecord.session_id -or $receipt.executor.model -cne $hostRecord.model -or $receipt.executor.reasoning_effort -cne 'medium') { throw 'Smoke did not pass under the attested tester identity.' }
    if (-not @($receipt.attempts | Where-Object { $_.outcome -eq 'Passed' -and $_.exit_code -eq 0 -and 'HOST/AC-001' -cin @($_.criteria) }).Count) { throw 'No executed HOST/AC-001 smoke criterion.' }
    $capturedFiles = @($receipt.before.source.files) + @($receipt.before.tests.files) + @($receipt.before.configuration.files) + @($receipt.before.fixtures.files) + @($receipt.before.dependencies.files)
    foreach ($requiredFile in @($configPath, $rolePath, $skillPath)) {
        $expectedHash = (Get-FileHash -LiteralPath $requiredFile).Hash
        if (-not @($capturedFiles | Where-Object { $_.path -eq $requiredFile -and $_.digest -eq $expectedHash -and $_.state -eq 'Present' }).Count) { throw 'Smoke scope did not capture current config, role and installed skill.' }
    }
    foreach ($attempt in $receipt.attempts) {
        foreach ($resource in @($attempt.stdout, $attempt.stderr, (Get-SweField $attempt 'observation'))) {
            if ($resource -and (Get-FileHash -LiteralPath $resource.path).Hash -ne $resource.digest) { throw 'Smoke output changed.' }
        }
    }
    if ((Get-FileHash -LiteralPath $receipt.request.path).Hash -ne $receipt.request.digest) { throw 'Smoke request changed.' }
    $request = Get-Content -Raw -LiteralPath $receipt.request.path | ConvertFrom-Json
    if ($request.repository -ne $root) { throw 'Smoke executed in a different destination.' }
    $fingerprint = (& (Join-Path $PSScriptRoot 'Invoke-SweChecks.ps1') -RequestPath $receipt.request.path -FingerprintOnly) | ConvertFrom-Json
    if ($fingerprint.digest -ne $receipt.before.digest -or $fingerprint.digest -ne $receipt.after.digest) { throw 'Smoke generation is stale.' }
    $hostStatus = 'AttestedSmokePassed'
} catch { $issues.Add("Host capability: $($_.Exception.Message)") }
[pscustomobject]@{
    schema = 'swe-adoption-preflight/v1'; target_version = $expected; destination = $root
    readiness = $(if ($issues.Count) { 'Blocked' } else { 'ReadyForReview' })
    packages = @($observations); policy_compatibility = $policyStatus; host_capability = $hostStatus
    reasons = @($issues); proposal = $proposal; destination_writes = 0; policy_activated = $false
    limitation = 'Host dispatch evidence is supplied by the actual host caller and must be reviewed there; this script cannot independently attest its own model or grant adoption.'
} | ConvertTo-Json -Depth 40
