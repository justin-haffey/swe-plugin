[CmdletBinding()]
param([Parameter(Mandatory)][string]$InputPath)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Swe-ArtifactFields.ps1')
$fields = Get-Content -Raw -LiteralPath (Join-Path $PSScriptRoot '../references/eligibility-fields.json') | ConvertFrom-Json
$inputRecord = Get-Content -Raw -LiteralPath $InputPath | ConvertFrom-Json
if ($inputRecord.schema -ne 'swe-packet-source/v1') { throw 'Unsupported packet source schema.' }
$missing = [Collections.Generic.List[string]]::new()
$sources = [Collections.Generic.List[object]]::new()
$packet = [ordered]@{ schema = $fields.packet_schema; assignment_id = $inputRecord.assignment_id; repository = $inputRecord.repository; phase = $inputRecord.phase }
if ($packet.phase -notin $fields.phases) { throw 'Unknown packet phase.' }
# Semantic findings are read from one explicitly named canonical artifact block.
# No caller-supplied positive flags or defaults stand in for reviewed findings.
$findingsAddress = Get-SweField $inputRecord 'findings_artifact'
if ($findingsAddress) {
    $source = Get-SweArtifactLocator $findingsAddress $packet.repository
    $sources.Add($source.locator)
    $packet.findings_source = $source.locator
    $blocks = [regex]::Matches($source.text, '(?ms)^```swe-eligibility\s*\r?\n(.*?)\r?\n```\s*$')
    if ($blocks.Count -ne 1) { $missing.Add('Exactly one canonical swe-eligibility findings block is required.') }
    else {
        $findings = $blocks[0].Groups[1].Value | ConvertFrom-Json
        if ($findings.assignment_id -cne $packet.assignment_id) { throw 'Findings belong to another assignment.' }
        foreach ($property in $findings.PSObject.Properties) {
            if ($property.Name -notin @('schema','assignment_id','repository','phase','findings_source')) { $packet[$property.Name] = $property.Value }
        }
    }
} else { $missing.Add('findings_artifact: reviewed semantic findings are unresolved.') }
function Freeze-Address($Address, [string]$Context) {
    try {
        $artifact = Get-SweArtifactLocator $Address $packet.repository
        $sources.Add($artifact.locator)
        return $artifact.locator
    } catch { $missing.Add("${Context}: $($_.Exception.Message)"); return $null }
}
foreach ($name in $fields.locators) {
    $address = Get-SweField (Get-SweField $inputRecord 'artifacts') $name
    if ($packet.Contains($name) -and $null -ne $packet[$name]) {
        $canonical = Freeze-Address $packet[$name] "findings.$name"
        if ($null -ne $address) {
            $supplied = Freeze-Address $address "artifacts.$name"
            if ($null -eq $canonical -or $null -eq $supplied -or $canonical.repository -ne $supplied.repository -or $canonical.path -ne $supplied.path -or $canonical.artifact_id -cne $supplied.artifact_id -or $canonical.sha256 -ne $supplied.sha256) { $missing.Add("artifacts.$name conflicts with the canonical findings locator.") }
        }
        $packet[$name] = $canonical
        continue
    }
    if ($null -ne $address) { $packet[$name] = Freeze-Address $address $name }
}
if ($packet.Contains('review') -and $packet.review) {
    foreach ($name in @('cycle_history','human_disposition')) {
        $address = Get-SweField $packet.review $name
        if ($address) { $packet.review.$name = Freeze-Address $address "review.$name" }
    }
    if ($packet.review.cycle_history) {
        $history = Get-SweArtifactLocator $packet.review.cycle_history $packet.repository
        $count = [regex]::Match($history.text, '(?m)^consumed_cycles:\s*(\d+)\s*$')
        if ($count.Success) {
            $existing = Get-SweField $packet.review 'consumed_cycles'
            if ($null -ne $existing -and $existing -ne [int]$count.Groups[1].Value) { $missing.Add('review.consumed_cycles conflicts with canonical history.') }
            $packet.review | Add-Member NoteProperty consumed_cycles ([int]$count.Groups[1].Value) -Force
        } else { $missing.Add('review.consumed_cycles is unresolved.') }
    }
}
foreach ($dependency in @($packet.dependencies)) {
    if ($null -eq $dependency) { continue }
    if (Get-SweField $dependency 'artifact') { $dependency.artifact = Freeze-Address $dependency.artifact 'dependency.artifact' }
}
foreach ($behavior in @(@($packet.dependencies | ForEach-Object { Get-SweField $_ 'behavior' }) + @($packet.delivery))) {
    if ($null -eq $behavior) { continue }
    if (Get-SweField $behavior 'validation') { $behavior.validation = Freeze-Address $behavior.validation 'behavior.validation' }
    # Preserve reviewer-bound receipt digests/generation. Never replace them with current bytes.
}
if ($packet.Contains('approval_policies')) { $packet.approval_policies = @($packet.approval_policies | ForEach-Object { Freeze-Address $_ 'approval_policies' }) }
foreach ($name in @($fields.required) + @($fields.phase_required.($packet.phase))) {
    if (-not $packet.Contains($name) -or $null -eq $packet[$name]) { $missing.Add("$name is unresolved.") }
}
foreach ($flag in $fields.risk_flags) {
    if ((Get-SweField $packet.risk $flag) -isnot [bool]) { $missing.Add("risk.$flag requires an explicit reviewed boolean.") }
}
if ((Get-SweField $packet.risk 'class') -notin @('Minimal','Standard','Major') -or -not (Get-SweField $packet.risk 'rationale')) { $missing.Add('Risk classification and rationale are unresolved.') }
foreach ($name in $fields.review_required) {
    if ($null -eq (Get-SweField $packet.review $name)) { $missing.Add("review.$name is unresolved.") }
}
[pscustomobject]@{ schema = 'swe-packet-build/v1'; packet = [pscustomobject]$packet; sources = @($sources); unresolved = @($missing); ready_for_audit = ($missing.Count -eq 0); grants_acceptance = $false; writes = 0 } | ConvertTo-Json -Depth 60
