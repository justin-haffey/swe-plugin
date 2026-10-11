[CmdletBinding()]
param([string]$ExecutorSession = $env:SWE_TEST_RUNNER_SESSION_ID)
$ErrorActionPreference = 'Stop'
if (-not $ExecutorSession) { throw 'Run from the actual native test-runner and provide its session ID.' }
$plugin = Split-Path -Parent $PSScriptRoot
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('swe-v4-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($scratch)
$count = 0
function Check([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "V4: $Message; fixtures retained at $scratch" }
    $script:count++
}
function Reject([scriptblock]$Action, [string]$Message) {
    $failed = $false
    try { $null = & $Action } catch { $failed = $true }
    Check $failed $Message
}
function Json([string]$Path, $Value) { [IO.File]::WriteAllText($Path, ($Value | ConvertTo-Json -Depth 30)) }
$copier = Join-Path $plugin 'skills/swe-scaffold/scripts/Invoke-SweScaffold.ps1'
$generator = Join-Path $PSScriptRoot 'New-SweArtifact.ps1'
$lineage = Join-Path $PSScriptRoot 'Get-SweArtifactLineage.ps1'
$standalone = Join-Path $scratch 'standalone'
$portfolio = Join-Path $scratch 'portfolio'
$childA = Join-Path $scratch 'child-a'
$childB = Join-Path $scratch 'child-b'
foreach ($directory in @($standalone,$portfolio,$childA,$childB)) { [void][IO.Directory]::CreateDirectory($directory) }
$first = & $copier -Solution -Destination $standalone
Check ($first.RequestedDeliveryMode -eq 'Standalone' -and $first.Counts.Created -gt 0) 'Fresh standalone scaffolding'
Check (([IO.File]::ReadAllText((Join-Path $standalone 'AGENTS.md'))) -match 'Delivery mode: Standalone') 'Standalone authority is explicit'
$hash = (Get-FileHash -LiteralPath (Join-Path $standalone 'AGENTS.md')).Hash
$replay = & $copier -Solution -Federated -PortfolioRepository portfolio -Destination $standalone
Check ($replay.Counts.Created -eq 0 -and $replay.GovernanceSkipped) 'Replay cannot change governance or create duplicate files'
Check ((Get-FileHash -LiteralPath (Join-Path $standalone 'AGENTS.md')).Hash -eq $hash) 'Existing bytes preserved even under requested mode change'
Reject { & $copier -Solution -Federated -Destination $childA } 'Federated requires real portfolio identity'
$null = & $copier -Portfolio -Destination $portfolio
foreach ($child in @($childA,$childB)) {
    $null = & $copier -Solution -Federated -PortfolioRepository portfolio -Destination $child
    Check (([IO.File]::ReadAllText((Join-Path $child 'AGENTS.md'))) -match 'Delivery mode: Federated\r?\nPortfolio repository: portfolio') 'Explicit federated child'
}
function Create-Artifact([string]$Repository,[string]$Relative,[string]$Type,[string]$Id,[string]$Template,$Links = @()) {
    $request = @{ schema_version = 4; template = $Template; metadata = @{ artifact_type = $Type; id = $Id; owners = @('fixture-author') }; artifact_links = @($Links); replacements = @{ FEATURE_TITLE = 'Export a report' } }
    $inputPath = Join-Path $scratch ('input-' + [guid]::NewGuid().ToString('N') + '.json')
    Json $inputPath $request
    $output = Join-Path $Repository $Relative
    $null = & $generator -InputPath $inputPath -OutputPath $output
    return $output
}
$featurePath = '.swe/features/001-export/FEATURE.md'
$feature = Create-Artifact $standalone $featurePath feature FEATURE-001 'skills/swe-plan-features/references/FEATURE-TEMPLATE.md'
$evidence = Create-Artifact $standalone '.swe/features/001-export/EVIDENCE.md' implementation_evidence EVIDENCE-001 'skills/swe-implement/references/EVIDENCE-TEMPLATE.md' @(@{ relation='subject'; artifact_id='FEATURE-001'; path=$featurePath })
$validation = Create-Artifact $standalone '.swe/features/001-export/VALIDATION.md' validation VALIDATION-001 'skills/swe-validate/references/VALIDATION-TEMPLATE.md' @(@{ relation='evidence'; artifact_id='EVIDENCE-001'; path='.swe/features/001-export/EVIDENCE.md' })
Check ((Get-ChildItem -LiteralPath (Split-Path -Parent $feature) -File).Count -eq 3) 'Ordinary standalone delivery has three records without Plan or Design'
$header = [regex]::Match([IO.File]::ReadAllText($evidence),'(?ms)\A---\r?\n(.*?)\r?\n---').Groups[1].Value
Check (($header -split '\r?\n').Count -le 10 -and $header -notmatch '(?m)^(parent|traceability|upstream):') 'Generated metadata stays compact'
$resolved = & $lineage -Repository $standalone -Path '.swe/features/001-export/VALIDATION.md' | ConvertFrom-Json
Check ($resolved.artifacts.Count -eq 3 -and -not $resolved.grants_acceptance) 'Direct chain resolves without a copied ancestor header or invented approval'
Reject { Create-Artifact $standalone $featurePath feature FEATURE-001 'skills/swe-plan-features/references/FEATURE-TEMPLATE.md' } 'Generation never clobbers work'
$sharedPath = '.swe/epics/001-export/features/001-export/FEATURE.md'
$shared = Create-Artifact $portfolio $sharedPath feature FEATURE-001 'skills/swe-plan-features/references/FEATURE-TEMPLATE.md'
$mapping = Join-Path $scratch 'repositories.json'; Json $mapping @{ portfolio=$portfolio }
foreach ($child in @($childA,$childB)) {
    $null = Create-Artifact $child '.swe/implementations/EPIC-001/FEATURE-001/DESIGN.md' design DESIGN-001 'skills/swe-design/references/DESIGN-TEMPLATE.md' @(@{ relation='feature'; repository='portfolio'; artifact_id='FEATURE-001'; path=$sharedPath })
    Reject { & $lineage -Repository $child -Path '.swe/implementations/EPIC-001/FEATURE-001/DESIGN.md' } 'Foreign ownership requires explicit mapping'
    $graph = & $lineage -Repository $child -Path '.swe/implementations/EPIC-001/FEATURE-001/DESIGN.md' -RepositoryMapPath $mapping | ConvertFrom-Json
    Check ($graph.artifacts.Count -eq 2) 'Two solutions resolve one canonical portfolio Feature'
    Check (-not (Test-Path -LiteralPath (Join-Path $child $sharedPath))) 'Portfolio Feature not copied to child'
}
$original = [IO.File]::ReadAllText($evidence)
[IO.File]::WriteAllText($evidence,$original.Replace('"artifact_id":"FEATURE-001"','"artifact_id":"FEATURE-WRONG"'))
Reject { & $lineage -Repository $standalone -Path '.swe/features/001-export/EVIDENCE.md' } 'Conflicting stable ID rejected'
[IO.File]::WriteAllText($evidence,$original)
$featureOriginal = [IO.File]::ReadAllText($feature)
[IO.File]::WriteAllText($feature,$featureOriginal.Replace('links: []','links: [{"relation":"cycle","artifact_id":"EVIDENCE-001","path":".swe/features/001-export/EVIDENCE.md"}]'))
Reject { & $lineage -Repository $standalone -Path $featurePath } 'Cycles rejected rather than treated as known ancestry'
[IO.File]::WriteAllText($feature,$featureOriginal)
$legacy = Join-Path $standalone 'LEGACY.md'
[IO.File]::WriteAllText($legacy,"---`nid: LEGACY-001`nstatus: Accepted`nupstream:`n  artifact_id: FEATURE-001`n  path: $featurePath`n---`n")
$legacyGraph = & $lineage -Repository $standalone -Path LEGACY.md | ConvertFrom-Json
Check ($legacyGraph.artifacts.Count -eq 2) 'Legacy full headers remain readable'
foreach ($type in @('bugfix','enhancement')) {
    $record = Create-Artifact $standalone ".swe/$type/001/RECORD.md" $type "$($type.ToUpper())-001" "skills/swe-$type/references/$($type.ToUpper())-TEMPLATE.md"
    Check ((Get-ChildItem -LiteralPath (Split-Path -Parent $record) -File).Count -eq 1) "$type stays a single record"
    Check (([IO.File]::ReadAllText($record)) -match '(?m)^status: "?Active"?\r?$') "$type begins Active"
}
# Use reviewed fixture decisions; eligibility remains an audit, not acceptance.
function Decision([string]$Name, [string]$Extra = '') {
    $path = "$Name.md"
    [IO.File]::WriteAllText((Join-Path $standalone $path), "---`nid: $Name`nstatus: Accepted`n---`n| Author | developer |`n| Approver | owner |`n| Mode | Human |`n| Decision | Accepted |`n$Extra")
    return @{ repository=$standalone; path=$path; artifact_id=$Name; sha256=(Get-FileHash -LiteralPath (Join-Path $standalone $path)).Hash }
}
$eligibility = Join-Path $PSScriptRoot 'Get-SweEligibility.ps1'
$packetPath = Join-Path $scratch 'eligibility.json'
$packet = @{
    schema='swe-eligibility/v2'; assignment_id='LOCAL-001'; repository=$standalone; phase='Implementation'; delivery_mode='Standalone'
    feature=(Decision 'APPROVED-FEATURE' '## Approach'); architecture=(Decision 'ARCHITECTURE')
    dependencies=@(); reviewed_independence=$true; behavior_consumers=@()
    review=@{ consumed_cycles=0; cycle_history=(Decision 'REVIEW' "consumed_cycles: 0`nunresolved: false") }
    risk=@{ class='Standard'; rationale='Isolated local behavior'; isolated=$true; reversible=$true; reviewed_deferral=$false; mandatory_early_checks=$false; public_contract=$false; cross_solution=$false; security=$false; persistence=$false; concurrency=$false; operational=$false }
}
Json $packetPath $packet
$entry = & $eligibility -InputPath $packetPath
Check ($entry.eligible -and -not $entry.grants_acceptance) 'Standalone implementation uses approved Feature approach without Plan or Design'
$packet.delivery_mode='Federated'; Json $packetPath $packet
$entry = & $eligibility -InputPath $packetPath
Check (-not $entry.eligible -and ($entry.reasons -join ' ') -match 'local Design') 'Federated implementation requires local Design'
$packet.design=Decision 'DESIGN'; Json $packetPath $packet
Check ((& $eligibility -InputPath $packetPath).eligible) 'Federated Design permits implementation without a redundant separate Plan'
$packet.delivery_mode='Standalone'; $packet.Remove('design'); $packet.feature=Decision 'NO-APPROACH'; Json $packetPath $packet
Check (-not (& $eligibility -InputPath $packetPath).eligible) 'Missing standalone approach does not bypass design review'
. (Join-Path $PSScriptRoot 'Swe-TesterProfile.ps1')
$profile = Get-SweTesterProfile $standalone
Check ($profile.model -eq 'gpt-6-luna' -and $profile.reasoning_effort -eq 'medium') 'Tester uses selected native role settings'
$nativeConfig = Join-Path $standalone '.codex/config.toml'
$configText = [IO.File]::ReadAllText($nativeConfig)
[IO.File]::WriteAllText($nativeConfig, $configText.Replace('[agents.test_runner]', '[agents.missing_tester]'))
Reject { Get-SweTesterProfile $standalone } 'Missing registered tester cannot silently substitute'
[IO.File]::WriteAllText($nativeConfig, $configText)
$collision = Join-Path $scratch 'collision'; [void][IO.Directory]::CreateDirectory($collision)
[IO.File]::WriteAllText((Join-Path $collision '.codex'),'occupied')
Reject { & $copier -Solution -Destination $collision } 'File/directory collision rejects before copying'
Check (-not (Test-Path -LiteralPath (Join-Path $collision 'AGENTS.md'))) 'Collision causes no partial guide'
Write-Output "V4 behavioral fixtures passed: $count assertions; $scratch"
