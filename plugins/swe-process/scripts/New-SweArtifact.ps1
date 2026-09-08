[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$InputPath,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [ValidateSet('Create', 'Update', 'Recovery')][string]$Mode = 'Create'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)
$pluginRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$inputFile = [IO.Path]::GetFullPath($InputPath)
$outputFile = [IO.Path]::GetFullPath($OutputPath)
$inputData = Get-Content -LiteralPath $inputFile -Raw | ConvertFrom-Json

function Value($Object, [string]$Name, $Default = $null) {
    if ($null -ne $Object -and $null -ne $Object.PSObject.Properties[$Name]) { return $Object.$Name }
    return $Default
}
function Scalar($Value) { return (ConvertTo-Json -InputObject ([string]$Value) -Compress) }
function Digest([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($utf8.GetBytes($Text)))).Replace('-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}
function Require-Text($Object, [string]$Name) {
    $value = Value $Object $Name
    if ($value -isnot [string] -or [string]::IsNullOrWhiteSpace($value) -or $value -match '[\r\n]') { throw "Required single-line string: $Name" }
    return $value
}
function Require-Relative([string]$Path) {
    if ([string]::IsNullOrWhiteSpace($Path) -or [IO.Path]::IsPathRooted($Path) -or $Path -match '(^|[/\\])\.\.([/\\]|$)|[\\\r\n:]|^/') { throw "Expected normalized repository-relative path: $Path" }
}
function Locator-Lines($Locator, [string]$Indent) {
    foreach ($key in @('repository', 'artifact_id', 'path')) {
        $value = Require-Text $Locator $key
        if ($key -eq 'path') { Require-Relative $value }
        "$Indent${key}: $(Scalar $value)"
    }
    $revision = Value $Locator 'revision'
    if ($null -ne $revision) { "$Indent" + 'revision: ' + (Scalar (Require-Text $Locator 'revision')) }
}
function Cell($Text) { return ([string]$Text).Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;').Replace('|', '&#124;').Replace("`r", ' ').Replace("`n", ' ') }
function New-Block([string]$Name, [string]$Body, [switch]$Yaml) {
    $bodyText = $Body.TrimEnd("`r", "`n") + "`n"
    $hash = Digest $bodyText
    if ($Yaml) { return "# swe:generated $Name sha256=$hash`n$bodyText# swe:end $Name" }
    return "<!-- swe:generated $Name sha256=$hash -->`n$bodyText<!-- swe:end $Name -->"
}
function Create-File([string]$Path, [string]$Text) {
    $directory = [IO.Path]::GetDirectoryName($Path)
    if (-not [IO.Directory]::Exists($directory)) { [void][IO.Directory]::CreateDirectory($directory) }
    $stream = New-Object IO.FileStream($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
    try { $bytes = $utf8.GetBytes($Text); $stream.Write($bytes, 0, $bytes.Length) } finally { $stream.Dispose() }
}

if ((Value $inputData 'schema_version') -ne 1) { throw 'Input schema_version must be 1.' }

if ($Mode -eq 'Recovery') {
    $lines = New-Object 'System.Collections.Generic.List[string]'
    $lines.Add('# Disposable SWE recovery view')
    $lines.Add('')
    $lines.Add('Derived observations only. Verify current artifacts, dirty state, live workers/processes, shared outputs, and receipts before continuing. This view cannot grant approval or reset review cycles.')
    $conflicts = New-Object 'System.Collections.Generic.List[string]'
    foreach ($kind in @('artifacts', 'receipts')) {
        if ($null -eq $inputData.PSObject.Properties[$kind]) { throw "Recovery requires $kind array (empty is explicit)." }
        foreach ($entry in @(Value $inputData $kind)) {
            $source = [IO.Path]::GetFullPath((Require-Text $entry 'path'))
            $lines.Add('')
            $lines.Add("## $kind input: $(Cell $source)")
            if (-not [IO.File]::Exists($source)) { $conflicts.Add("Missing input: $source"); $lines.Add('Missing; state unknown.'); continue }
            $raw = [IO.File]::ReadAllText($source)
            $hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant()
            $lines.Add("SHA-256: $hash")
            $expected = Value $entry 'sha256'
            if ($expected -and $expected -ne $hash) { $conflicts.Add("Input fingerprint changed: $source") }
            if ($kind -eq 'artifacts') {
                $observations = [regex]::Matches($raw, '(?m)^\s*(?:-\s*)?(status|implementation|verification|acceptance|source_generation|check_id|criteria|reason|due|owner|pending_obligations):[^\r\n]*')
                foreach ($observation in $observations) { $lines.Add('- ' + (Cell $observation.Value.Trim())) }
                if ($raw -match '(?m)^\s*acceptance:\s*["'']?Accepted' -and $raw -notmatch '(?m)^\s*verification:\s*["'']?Complete') { $conflicts.Add("Accepted progress without complete verification: $source") }
            } else {
                try {
                    $receipt = $raw | ConvertFrom-Json
                    foreach ($field in @('execution_id', 'outcome', 'result', 'status', 'source_generation', 'changed_during_run', 'pending_obligations', 'checks', 'blockers')) {
                        $value = Value $receipt $field
                        if ($null -ne $value) { $lines.Add("- ${field}: $(Cell (ConvertTo-Json -InputObject $value -Depth 20 -Compress))") }
                    }
                    $claimedArtifact = Value $entry 'artifact_path'
                    if ($claimedArtifact) {
                        $claimedPath = [IO.Path]::GetFullPath([string]$claimedArtifact)
                        if (-not [IO.File]::Exists($claimedPath)) { $conflicts.Add("Missing receipt-associated artifact: $claimedPath") }
                        else {
                            $claimedText = [IO.File]::ReadAllText($claimedPath)
                            $outcome = Value $receipt 'outcome' (Value $receipt 'result' (Value $receipt 'status' 'unknown'))
                            if ($claimedText -match '(?m)^\s*(verification:\s*["'']?Complete|acceptance:\s*["'']?Accepted)' -and $outcome -notin @('Passed', 'Pass')) { $conflicts.Add("Completed/accepted progress disagrees with associated receipt outcome '$outcome': $claimedPath -> $source") }
                            $sourceGeneration = Value $receipt 'source_generation'
                            $artifactGeneration = [regex]::Match($claimedText, '(?m)^\s*source_generation:\s*["'']?(?<value>[^\r\n"'']+)')
                            if ($sourceGeneration -and $artifactGeneration.Success -and $artifactGeneration.Groups['value'].Value.Trim() -ne [string]$sourceGeneration) { $conflicts.Add("Associated artifact and receipt source generations disagree: $claimedPath -> $source") }
                        }
                    }
                } catch { $conflicts.Add("Unreadable receipt JSON: $source") }
            }
        }
    }
    $lines.Add(''); $lines.Add('## Execution hints requiring live verification')
    foreach ($field in @('handles', 'policy_locator', 'cycle_history_locator', 'last_verified_generation', 'next_action')) {
        $value = Value $inputData $field 'unknown'
        $lines.Add("- ${field}: $(Cell (ConvertTo-Json -InputObject $value -Depth 20 -Compress))")
    }
    $lines.Add(''); $lines.Add('## Disagreements and blockers')
    if ($conflicts.Count -eq 0) { $lines.Add('None found in the inspected fields; verify semantic correspondence and current runtime before use.') }
    else { foreach ($conflict in $conflicts) { $lines.Add('- ' + (Cell $conflict)) } }
    Create-File $outputFile (($lines -join "`n") + "`n")
    [pscustomobject]@{ mode = $Mode; path = $outputFile; conflicts = @($conflicts.ToArray()); trusted_for_resume = $false } | ConvertTo-Json -Depth 10
    return
}

$templateName = Require-Text $inputData 'template'
Require-Relative $templateName
if ($templateName -notmatch '^skills/[^/]+/references/.+-TEMPLATE\.md$') { throw 'Template must belong to its creating skill references directory.' }
$templateFile = [IO.Path]::GetFullPath((Join-Path $pluginRoot $templateName))
if (-not $templateFile.StartsWith($pluginRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Template escapes plugin root.' }
$isArchitecture = $templateName -match '^skills/swe-architect/references/v[12]/'
if ($isArchitecture) {
    $profile = Value $inputData 'profile' 'Compact'
    if ($profile -notin @('Compact', 'Detailed')) { throw 'Architecture profile must be Compact or Detailed.' }
    $profileRationale = Require-Text $inputData 'profile_rationale'
    if ($profile -eq 'Compact' -and @(Value $inputData 'critical_concerns' @()).Count -gt 0) { throw 'Critical concerns require Detailed, or an independently reviewed focused Compact addition outside generation.' }
    $version = if ($profile -eq 'Compact') { 'v1' } else { 'v2' }
    $templateName = $templateName -replace '/v[12]/', "/$version/"
    $templateFile = Join-Path $pluginRoot $templateName
}
$templateText = [IO.File]::ReadAllText($templateFile).Replace("`r`n", "`n")
$headerMatch = [regex]::Match($templateText, '\A---\s*\n(?<body>.*?)\n---\s*\n', [Text.RegularExpressions.RegexOptions]::Singleline)
if (-not $headerMatch.Success) { throw 'Template lacks bounded YAML metadata.' }
$metadata = Value $inputData 'metadata'
$metaLines = New-Object 'System.Collections.Generic.List[string]'
$artifactType = Require-Text $metadata 'artifact_type'
if ($headerMatch.Groups['body'].Value -notmatch ('(?m)^artifact_type:\s*"?' + [regex]::Escape($artifactType) + '"?\s*$')) { throw 'Template and requested artifact_type differ.' }
$allowedTypes = @('epic','research','concept','architecture_impact','feature','implementation_plan','design','implementation_evidence','validation','platform_architecture','solution_architecture','package_architecture','module_architecture','system_view','architecture_decision','architecture_contract')
if ($artifactType -notin $allowedTypes) { throw "Unsupported artifact_type: $artifactType" }
$status = if ($artifactType -match '_architecture$|^system_view$') { 'Target' } elseif ($artifactType -in @('architecture_decision', 'architecture_contract')) { 'Proposed' } else { 'Draft' }
if ($null -ne $metadata.PSObject.Properties['status']) { throw 'The helper sets initial lifecycle; metadata.status is not an input.' }
foreach ($field in @('title', 'artifact_type', 'id')) { $metaLines.Add("${field}: $(Scalar (Require-Text $metadata $field))") }
if ((Require-Text $metadata 'id') -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$') { throw 'Invalid stable artifact ID.' }
$metaLines.Add("status: $(Scalar $status)")
foreach ($field in @('authority', 'scope', 'parent')) { $metaLines.Add("${field}: $(Scalar (Require-Text $metadata $field))") }
if ((Value $metadata 'authority') -notin @('portfolio', 'solution')) { throw 'Authority must be portfolio or solution.' }
$metaLines.Add('upstream:')
foreach ($line in @(Locator-Lines (Value $inputData 'upstream') '  ')) { $metaLines.Add($line) }
$traceability = Value $inputData 'traceability'
if ($null -ne $traceability) {
    $metaLines.Add('traceability:')
    foreach ($property in @($traceability.PSObject.Properties | Sort-Object Name)) {
        if ($property.Name -notmatch '^[a-z][a-z0-9_]*$') { throw 'Traceability keys must be snake_case.' }
        $metaLines.Add('  ' + $property.Name + ':')
        foreach ($line in @(Locator-Lines $property.Value '    ')) { $metaLines.Add($line) }
    }
}
$owners = @(Value $metadata 'owners' @())
if ($owners.Count -eq 0) { throw 'Metadata requires at least one owner.' }
$metaLines.Add('owners:')
foreach ($owner in $owners) { if ([string]::IsNullOrWhiteSpace($owner)) { throw 'Empty owner.' }; $metaLines.Add('  - ' + (Scalar $owner)) }
foreach ($field in @('created', 'updated')) {
    $date = Require-Text $metadata $field
    $parsedDate = [datetime]::MinValue
    if (-not [datetime]::TryParseExact($date, 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$parsedDate)) { throw "Invalid ISO date: $field" }
    $metaLines.Add("${field}: $(Scalar $date)")
}
$metaLines.Add('template_version: "3.0.0"')
$metadataBlock = New-Block 'metadata' ($metaLines -join "`n") -Yaml

$indexLines = New-Object 'System.Collections.Generic.List[string]'
$indexLines.Add('## Generated Traceability')
$indexLines.Add(''); $indexLines.Add('Mechanical index only; criterion judgments and approvals remain independently authored.')
$indexLines.Add(''); $indexLines.Add('| Criterion | Owner | Expected evidence locator |'); $indexLines.Add('|---|---|---|')
$criterionIds = @{}
foreach ($criterion in @(Value $inputData 'criteria' @())) {
    $id = Require-Text $criterion 'id'
    if ($id -notmatch '^AC-\d{3}$' -or $criterionIds.ContainsKey($id)) { throw "Invalid or duplicate criterion ID: $id" }
    $criterionIds[$id] = $true
    $indexLines.Add("| $(Cell $id) | $(Cell (Require-Text $criterion 'owner')) | $(Cell (Require-Text $criterion 'evidence')) |")
}
$indexLines.Add(''); $indexLines.Add('| Assignment | Repository | Local artifact path | Criteria |'); $indexLines.Add('|---|---|---|---|')
$assignmentIds = @{}
foreach ($assignment in @(Value $inputData 'assignments' @())) {
    $id = Require-Text $assignment 'id'
    if ($assignmentIds.ContainsKey($id)) { throw "Duplicate assignment ID: $id" }; $assignmentIds[$id] = $true
    $path = Require-Text $assignment 'path'; Require-Relative $path
    $assignedCriteria = @(Value $assignment 'criteria' @())
    if ($assignedCriteria.Count -eq 0) { throw "Assignment has no criteria: $id" }
    foreach ($criterion in $assignedCriteria) { if (-not $criterionIds.ContainsKey([string]$criterion)) { throw "Assignment $id references unknown criterion: $criterion" } }
    $indexLines.Add("| $(Cell $id) | $(Cell (Require-Text $assignment 'repository')) | $(Cell $path) | $(Cell ($assignedCriteria -join ', ')) |")
}
$indexLines.Add(''); $indexLines.Add('Upstream locator: ' + (Cell (Require-Text (Value $inputData 'upstream') 'artifact_id')) + ' in ' + (Cell (Require-Text (Value $inputData 'upstream') 'repository')) + ', ' + (Cell (Require-Text (Value $inputData 'upstream') 'path')))
foreach ($link in @(Value $inputData 'links' @())) {
    $label = Require-Text $link 'label'
    $target = Require-Text $link 'target'
    if ($target -match '[<>\r\n]' -or [IO.Path]::IsPathRooted($target) -or $target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:') { throw 'Cross-links must be explicit relative local targets.' }
    $resolvedLink = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetDirectoryName($outputFile)) $target))
    if (-not [IO.File]::Exists($resolvedLink)) { throw "Cross-link target does not exist: $target" }
    $safeLabel = (Cell $label).Replace('[', '&#91;').Replace(']', '&#93;')
    $indexLines.Add("- [$safeLabel](<$($target.Replace('\', '/'))>)")
}
if ($isArchitecture) { $indexLines.Add("Profile: $profile. $(Cell $profileRationale)") }
$traceabilityBlock = New-Block 'traceability' ($indexLines -join "`n")
$body = $templateText.Substring($headerMatch.Length)
if ($isArchitecture) {
    if ($body -notmatch '(?m)^## Approval Record\s*$' -or $body.Length -lt 400) { throw 'Architecture template is incomplete.' }
    if ($artifactType -match '_architecture$') {
        foreach ($concern in @('Boundary|Boundaries', 'Invariant', 'Alternative', 'Failure', 'Secur', 'Operat', 'Traceability', 'Divergence', 'Feasibility')) {
            if ($body -notmatch $concern) { throw "Architecture template lacks required concern: $concern" }
        }
    }
}
$replacements = Value $inputData 'replacements'
if ($null -ne $replacements) {
    foreach ($property in $replacements.PSObject.Properties) {
        if ($property.Name -notmatch '^[A-Z][A-Z0-9_]*$' -or [string]$property.Value -match '[\r\n]') { throw 'Replacements must use uppercase keys and single-line literal values.' }
        if ($property.Name -match 'APPROV|DECISION|ACCEPTED|RECORDED|BYPASS|REVIEW_REFERENCE|CYCLE') { throw "Decision placeholders remain authored: $($property.Name)" }
        $body = $body.Replace('[' + $property.Name + ']', [string]$property.Value)
    }
}
$newText = "---`n$metadataBlock`n---`n`n$($body.TrimEnd())`n`n$traceabilityBlock`n"
if ($Mode -eq 'Create') { Create-File $outputFile $newText }
else {
    $current = [IO.File]::ReadAllText($outputFile)
    if ($current -match '(?m)^status:\s*["'']?(Accepted|Current|Implemented|Superseded|InReview)["'']?\s*$|(?m)^\|\s*Decision\s*\|\s*(Accepted|Bypassed)\s*\|') { throw 'Frozen lifecycle/approval cannot be regenerated; create an explicit successor or return an unaccepted review to Draft through governance.' }
    if ($current -notmatch ('(?m)^id:\s*' + [regex]::Escape((Scalar (Value $metadata 'id'))) + '\s*$')) { throw 'Update identity mismatch or unsupported legacy metadata; preserve it and author an explicit successor.' }
    $updates = @(
        @{ Name = 'metadata'; Pattern = '(?ms)^# swe:generated metadata sha256=(?<hash>[a-f0-9]{64})\r?\n(?<body>.*?)^# swe:end metadata'; Block = $metadataBlock },
        @{ Name = 'traceability'; Pattern = '(?ms)^<!-- swe:generated traceability sha256=(?<hash>[a-f0-9]{64}) -->\r?\n(?<body>.*?)^<!-- swe:end traceability -->'; Block = $traceabilityBlock }
    )
    $conflictLines = New-Object 'System.Collections.Generic.List[string]'
    foreach ($update in $updates) {
        $matches = [regex]::Matches($current, $update.Pattern)
        if ($matches.Count -ne 1) { throw "Expected one marked generated $($update.Name) block; preserve legacy/manual content." }
        $match = $matches[0]
        if ((Digest $match.Groups['body'].Value.Replace("`r`n", "`n")) -ne $match.Groups['hash'].Value) {
            $conflictLines.Add("@@ generated $($update.Name) manual conflict @@")
            foreach ($line in ($match.Value -split '\r?\n')) { $conflictLines.Add('-' + $line) }
            foreach ($line in ($update.Block -split '\r?\n')) { $conflictLines.Add('+' + $line) }
        }
    }
    if ($conflictLines.Count -gt 0) {
        $diffPath = $outputFile + '.generated-conflict.diff'
        Create-File $diffPath (($conflictLines -join "`n") + "`n")
        throw "Generated content conflicts; artifact unchanged. Exact proposed/current diff: $diffPath"
    }
    $updated = $current
    foreach ($update in $updates) {
        $match = [regex]::Match($updated, $update.Pattern)
        $updated = $updated.Substring(0, $match.Index) + $update.Block + $updated.Substring($match.Index + $match.Length)
    }
    # Detect concurrent edits again immediately before the bounded write.
    $stream = New-Object IO.FileStream($outputFile, [IO.FileMode]::Open, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    try {
        $reader = New-Object IO.StreamReader($stream, $utf8, $true, 1024, $true)
        try { $live = $reader.ReadToEnd() } finally { $reader.Dispose() }
        if ($live -cne $current) { throw 'Artifact changed during generation; retry after reconciling current bytes.' }
        $bytes = $utf8.GetBytes($updated); $stream.Position = 0; $stream.Write($bytes, 0, $bytes.Length); $stream.SetLength($bytes.Length)
    } finally { $stream.Dispose() }
}
[pscustomobject]@{ mode = $Mode; path = $outputFile; artifact_id = Value $metadata 'id'; template = $templateName; status = $status; generated_sha256 = Digest ([IO.File]::ReadAllText($outputFile)) } | ConvertTo-Json
