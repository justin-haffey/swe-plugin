[CmdletBinding()]
param(
    [string]$PluginRoot,
    [string]$ExecutorSession = $env:SWE_TEST_RUNNER_SESSION_ID
)

# Execute this rehearsal only from the actual test-runner session. These are
# deliberately tiny native commands; they test receipt behavior, not application code.
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ExecutorSession)) { throw 'Set SWE_TEST_RUNNER_SESSION_ID to the actual Luna/medium test-runner session before executing fixtures.' }
if ([string]::IsNullOrWhiteSpace($PluginRoot)) { $PluginRoot = Split-Path -Parent $PSScriptRoot }
$PluginRoot = (Resolve-Path -LiteralPath $PluginRoot).Path
$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PluginRoot)
$checksHelper = Join-Path $PluginRoot 'scripts\Invoke-SweChecks.ps1'
$artifactHelper = Join-Path $PluginRoot 'scripts\New-SweArtifact.ps1'
$migrationHelper = Join-Path $PluginRoot 'scripts\Get-SweMigrationDiff.ps1'
foreach ($helper in @($checksHelper, $artifactHelper, $migrationHelper)) {
    if (-not (Test-Path -LiteralPath $helper -PathType Leaf)) { throw "Required V3 helper is unavailable: $helper" }
}
$fixtureRoot = Join-Path ([IO.Path]::GetTempPath()) ('swe-v3-rehearsal-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($fixtureRoot)
$assertions = 0
function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "Fixture failed: $Message. Rehearsal retained at $fixtureRoot" }
    $script:assertions++
}
function Write-Json([string]$Path, $Value) { [IO.File]::WriteAllText($Path, (ConvertTo-Json -InputObject $Value -Depth 35)) }
function Assert-Rejected([scriptblock]$Action, [string]$Message) {
    $rejected = $false
    try { $null = & $Action } catch { $rejected = $true }
    Assert-True $rejected $Message
}
$shell = (Get-Process -Id $PID).Path
$producer = Join-Path $fixtureRoot 'solution-contract'
$consumer = Join-Path $fixtureRoot 'solution-consumer'
$portfolio = Join-Path $fixtureRoot 'portfolio'
foreach ($directory in @($producer, $consumer, $portfolio)) { [void][IO.Directory]::CreateDirectory($directory) }
foreach ($directory in @($producer, $consumer)) {
    foreach ($child in @('src', 'tests', 'config', 'fixtures', 'dependency', 'output')) { [void][IO.Directory]::CreateDirectory((Join-Path $directory $child)) }
    [IO.File]::WriteAllText((Join-Path $directory 'src\source.txt'), 'generation-1')
    [IO.File]::WriteAllText((Join-Path $directory 'dependency\generation.txt'), 'dependency-1')
}
$passScript = Join-Path $producer 'tests\pass.ps1'
$failScript = Join-Path $producer 'tests\fail.ps1'
$dirtyScript = Join-Path $producer 'tests\dirty.ps1'
$observeScript = Join-Path $producer 'tests\observe.ps1'
[IO.File]::WriteAllText($passScript, "Write-Output 'one actual execution'; exit 0")
[IO.File]::WriteAllText($failScript, "Write-Error 'intentional assertion failure' -ErrorAction Continue; exit 7")
[IO.File]::WriteAllText($dirtyScript, "[IO.File]::WriteAllText((Join-Path (Get-Location) 'src/source.txt'), 'generation-2'); exit 0")
[IO.File]::WriteAllText($observeScript, 'param([string]$InputFile,[string]$OutputFile); [IO.File]::WriteAllText($OutputFile,(Get-Content -Raw -LiteralPath $InputFile)); exit 0')
function New-Request([string]$Script = $passScript) {
    return [ordered]@{
        schema = 'swe-check-request/v1'; repository = $producer
        assignment = @{ repository = $portfolio; artifact_id = 'PLAN-001'; path = 'IMPLEMENTATION-PLAN.md'; revision = 'fixture-1' }
        criteria = @('FEATURE-001/AC-001', 'FEATURE-003/AC-001')
        scope = @{ source = @('src'); tests = @('tests'); configuration = @('config'); fixtures = @('fixtures'); dependencies = @('dependency') }
        runtime = @{ identity = $PSVersionTable.PSVersion.ToString(); paths = @($shell) }
        checks = @(@{ id = 'native'; executable = $shell; arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $Script); working_directory = '.'; timeout_seconds = 20; criteria = @('FEATURE-001/AC-001', 'FEATURE-003/AC-001') })
        risk = 'Major'; timing = 'Early'; scope_rationale = 'Bounded fixture rehearsal; empty directories deliberately represent no additional configuration or fixtures.'; prerequisites = @(); result_directory = (Join-Path $fixtureRoot 'receipts'); shared_outputs = @()
        execution_role = 'test-runner'; executor = @{ role = 'test-runner'; model = 'gpt-5.6-luna'; reasoning_effort = 'medium'; session_id = $ExecutorSession }
    }
}
function Invoke-Receipt($Request) {
    $path = Join-Path $fixtureRoot ('request-' + [guid]::NewGuid().ToString('N') + '.json')
    Write-Json $path $Request
    $receiptPath = & $checksHelper -RequestPath $path
    Assert-True (Test-Path -LiteralPath $receiptPath -PathType Leaf) 'Each execution returns a durable receipt'
    return Get-Content -Raw -LiteralPath $receiptPath | ConvertFrom-Json
}
$passing = Invoke-Receipt (New-Request)
Assert-True ($passing.outcome -eq 'Passed' -and $passing.reusable) 'Scoped passing execution is reusable'
Assert-True ($passing.attempts.Count -eq 1 -and $passing.attempts[0].criteria.Count -eq 2) 'One native run preserves two Feature criterion locators'
Assert-True ($passing.executor.session_id -eq $ExecutorSession -and $passing.before.digest -eq $passing.after.digest) 'Receipt identifies actual executor and exact unchanged generation'
Assert-True ($null -eq $passing.PSObject.Properties['approval'] -and $null -eq $passing.PSObject.Properties['decision']) 'Green observations never create an acceptance decision'
$failing = Invoke-Receipt (New-Request $failScript)
Assert-True ($failing.outcome -eq 'Failed' -and $failing.attempts[0].exit_code -eq 7 -and $failing.attempts.Count -eq 1 -and -not $failing.reusable) 'Assertion failure is preserved without automatic retry'
$request = New-Request
$request.checks[0].executable = 'swe-intentionally-unavailable-tool-9f08'
$unavailable = Invoke-Receipt $request
Assert-True ($unavailable.outcome -eq 'Blocked' -and $unavailable.missing_coverage.Count -eq 2 -and -not $unavailable.reusable) 'Missing tool remains blocked with pending criteria'
$request = New-Request
$request.checks[0].observation_path = Join-Path $fixtureRoot 'unproduced-observation.json'
$unproduced = Invoke-Receipt $request
Assert-True ($unproduced.outcome -eq 'Blocked') 'Requested native observation must exist even when no concrete cases were supplied'
$request = New-Request
$request.expected_fingerprint = ('0' * 64)
$stale = Invoke-Receipt $request
Assert-True ($stale.outcome -eq 'Blocked' -and $stale.attempts.Count -eq 0) 'Stale expected generation is rejected before execution'
$changed = Invoke-Receipt (New-Request $dirtyScript)
Assert-True ($changed.outcome -eq 'Blocked' -and $changed.changed_during_run -and -not $changed.reusable) 'Dirty changes invalidate an otherwise green run'
$request = New-Request
$request.expected_fingerprint = $passing.before.digest
$staleSource = Invoke-Receipt $request
Assert-True ($staleSource.outcome -eq 'Blocked' -and $staleSource.attempts.Count -eq 0) 'Changed source cannot reuse prior generation'
$fresh = Invoke-Receipt (New-Request)
Assert-True ($fresh.outcome -eq 'Passed' -and $fresh.execution_id -ne $passing.execution_id) 'Resume creates new attributable execution without rewriting prior evidence'
[IO.File]::WriteAllText((Join-Path $producer 'dependency\generation.txt'), 'dependency-2')
$request = New-Request
$request.expected_fingerprint = $fresh.before.digest
$dependencyChanged = Invoke-Receipt $request
Assert-True ($dependencyChanged.outcome -eq 'Blocked' -and $dependencyChanged.attempts.Count -eq 0) 'Dependency output changes reject old evidence'

# Wrong participant/operation, missing realized cases, and duplicate observations
# must not satisfy coverage merely because the native process exited zero.
$expectedCase = @{ id = 'CASE-001'; participant = 'consumer'; operation = 'Execute'; fixture = 'FIX-001'; expected = '42' }
foreach ($variant in @('correct', 'wrong-participant', 'wrong-operation', 'unrealized', 'duplicate')) {
    $request = New-Request
    $observationInput = Join-Path $producer ('fixtures\' + $variant + '.json')
    $observationOutput = Join-Path $fixtureRoot ('observation-' + $variant + '.json')
    $case = @{ id = 'CASE-001'; participant = 'consumer'; operation = 'Execute'; fixture = 'FIX-001'; expected = '42'; actual = '42'; outcome = 'Passed' }
    if ($variant -eq 'wrong-participant') { $case.participant = 'producer' }
    if ($variant -eq 'wrong-operation') { $case.operation = 'Compile' }
    $cases = @($case)
    if ($variant -eq 'unrealized') { $cases = @() }
    if ($variant -eq 'duplicate') { $cases = @($case, $case) }
    Write-Json $observationInput @{ counts = @{ passed = 1 }; cases = $cases }
    $request.checks[0].arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $observeScript, $observationInput, $observationOutput)
    $request.checks[0].observation_path = $observationOutput
    $request.checks[0].cases = @($expectedCase)
    $receipt = Invoke-Receipt $request
    $expectedOutcome = if ($variant -eq 'correct') { 'Passed' } else { 'Blocked' }
    Assert-True ($receipt.outcome -eq $expectedOutcome) "Concrete case attribution: $variant"
}
$lockPath = Join-Path $producer 'output\.swe-check.lock'
$lock = [IO.File]::Open($lockPath, [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
try {
    $request = New-Request
    $request.shared_outputs = @(@{ path = (Join-Path $producer 'output'); generation = 'dependency-2' })
    $overlap = Invoke-Receipt $request
    Assert-True ($overlap.outcome -eq 'Blocked' -and $overlap.attempts.Count -eq 0) 'Shared-output overlap blocks before launch'
} finally { $lock.Dispose() }
$serialized = Invoke-Receipt $request
Assert-True ($serialized.outcome -eq 'Passed' -and $serialized.shared_outputs[0].generation -eq 'dependency-2') 'Released output lease permits execution with explicit generation'

# Migration observes customized destinations and never activates new policy.
$proposed = Join-Path $fixtureRoot 'proposed'
$baseline = Join-Path $fixtureRoot 'baseline'
foreach ($path in @($proposed, $baseline)) { [void][IO.Directory]::CreateDirectory($path) }
[IO.File]::WriteAllText((Join-Path $baseline 'AGENTS.md'), 'legacy policy')
[IO.File]::WriteAllText((Join-Path $consumer 'AGENTS.md'), 'custom policy')
[IO.File]::WriteAllText((Join-Path $proposed 'AGENTS.md'), 'V3 policy')
[IO.File]::WriteAllText((Join-Path $consumer 'custom-agent.toml'), 'preserve settings')
$before = (Get-FileHash -LiteralPath (Join-Path $consumer 'AGENTS.md')).Hash
$migration = & $migrationHelper -Destination $consumer -Proposed $proposed -Baseline $baseline
Assert-True ($migration.Mode -eq 'DryRun' -and $migration.DestinationWrites -eq 0 -and -not $migration.PolicyActivated) 'Migration remains an inactive dry run'
Assert-True ((Get-FileHash -LiteralPath (Join-Path $consumer 'AGENTS.md')).Hash -eq $before) 'Migration preserves customized governance bytes'
Assert-True (@($migration.Changes | Where-Object { $_.Path -eq 'AGENTS.md' -and $_.Classification -eq 'CustomizationConflict' }).Count -eq 1) 'Customized governance conflict is explicit'

# Artifact generation selects a profile per artifact and cannot rewrite accepted
# legacy decisions or hand-edited generated bytes.
$artifactInputPath = Join-Path $fixtureRoot 'artifact-input.json'
$modulePath = Join-Path $consumer 'MODULE-ARCHITECTURE.md'
$artifactInput = @{
    schema_version = 1; template = 'skills/swe-architect/references/v1/MODULE-ARCHITECTURE-TEMPLATE.md'
    profile_rationale = 'Ordinary isolated module with bounded implementation choices.'
    metadata = @{ title = 'Fixture Module'; artifact_type = 'module_architecture'; id = 'ARCH-MODULE-FIXTURE'; authority = 'solution'; scope = 'package/module'; parent = 'ARCH-PACKAGE-FIXTURE'; owners = @('fixture-author'); created = '2026-09-07'; updated = '2026-09-07' }
    upstream = @{ repository = 'fixture-consumer'; artifact_id = 'ARCH-PACKAGE-FIXTURE'; path = 'PACKAGE-ARCHITECTURE.md'; revision = 'fixture-1' }
    criteria = @(@{ id = 'AC-001'; owner = 'fixture-author'; evidence = 'EVIDENCE.md' })
    assignments = @(@{ id = 'ASSIGN-003'; repository = 'fixture-consumer'; path = 'DESIGN.md'; criteria = @('AC-001') })
}
Write-Json $artifactInputPath $artifactInput
$null = & $artifactHelper -InputPath $artifactInputPath -OutputPath $modulePath
$moduleText = Get-Content -Raw -LiteralPath $modulePath
Assert-True ($moduleText -match 'Profile: Compact' -and $moduleText -match 'status: "Target"' -and $moduleText -match 'ARCH-MODULE-FIXTURE') 'Ordinary module defaults to Compact with stable identity and unapproved Target status'
Assert-Rejected { & $artifactHelper -InputPath $artifactInputPath -OutputPath $modulePath } 'Create refuses to overwrite an existing artifact'
$artifactInput.critical_concerns = @('concurrency boundary')
Write-Json $artifactInputPath $artifactInput
Assert-Rejected { & $artifactHelper -InputPath $artifactInputPath -OutputPath (Join-Path $consumer 'critical-compact.md') } 'Compact selection cannot waive a critical concern'
$artifactInput.profile = 'Detailed'
$artifactInput.profile_rationale = 'Concurrency boundary requires detailed failure and scenario analysis.'
Write-Json $artifactInputPath $artifactInput
$detailedPath = Join-Path $consumer 'critical-detailed.md'
$null = & $artifactHelper -InputPath $artifactInputPath -OutputPath $detailedPath
Assert-True ((Get-Content -Raw -LiteralPath $detailedPath) -match 'Profile: Detailed') 'Critical module selects Detailed independently'
Assert-True ((Get-Content -Raw -LiteralPath $modulePath) -ceq $moduleText) 'Detailed selection leaves unrelated Compact artifact unchanged'
$legacy = Join-Path $consumer 'legacy-accepted.md'
[IO.File]::WriteAllText($legacy, @'
---
id: "ARCH-MODULE-LEGACY"
status: "Accepted"
upstream:
  artifact_id: "FEATURE-001"
  path: "epics/EPIC-001/FEATURE-001.md"
---
Accepted legacy semantics and history.
'@)
$legacyHash = (Get-FileHash -LiteralPath $legacy).Hash
Assert-Rejected { & $artifactHelper -Mode Update -InputPath $artifactInputPath -OutputPath $legacy } 'Legacy accepted content is never silently regenerated'
Assert-True ((Get-FileHash -LiteralPath $legacy).Hash -eq $legacyHash) 'Accepted legacy IDs, locators and history remain byte-identical'
$artifactInput.Remove('critical_concerns'); $artifactInput.Remove('profile')
$artifactInput.metadata.title = 'Revised generated title'
Write-Json $artifactInputPath $artifactInput
[IO.File]::AppendAllText($modulePath, "`nHuman-authored decision notes remain here.`n")
$null = & $artifactHelper -Mode Update -InputPath $artifactInputPath -OutputPath $modulePath
Assert-True ((Get-Content -Raw -LiteralPath $modulePath) -match 'Human-authored decision notes remain here') 'Regeneration preserves authored decision content'
$manualText = (Get-Content -Raw -LiteralPath $modulePath).Replace('Revised generated title', 'Manual generated-block edit')
[IO.File]::WriteAllText($modulePath, $manualText)
Assert-Rejected { & $artifactHelper -Mode Update -InputPath $artifactInputPath -OutputPath $modulePath } 'Conflicting generated edits require review'
Assert-True ((Get-Content -Raw -LiteralPath $modulePath) -ceq $manualText) 'Generated conflict leaves artifact unchanged'

# Incomplete profile fixture uses an isolated copy of the real generator, never a
# test-only validator or a mutation to the distributed template.
$fixturePlugin = Join-Path $fixtureRoot 'incomplete-plugin'
$fixtureScripts = Join-Path $fixturePlugin 'scripts'
$fixtureTemplateRoot = Join-Path $fixturePlugin 'skills\swe-architect\references\v1'
[void][IO.Directory]::CreateDirectory($fixtureScripts)
[void][IO.Directory]::CreateDirectory($fixtureTemplateRoot)
Copy-Item -LiteralPath $artifactHelper -Destination (Join-Path $fixtureScripts 'New-SweArtifact.ps1')
$templateText = Get-Content -Raw -LiteralPath (Join-Path $PluginRoot $artifactInput.template)
[IO.File]::WriteAllText((Join-Path $fixtureTemplateRoot 'MODULE-ARCHITECTURE-TEMPLATE.md'), ($templateText -replace '(?i)failure', 'fault'))
Assert-Rejected { & (Join-Path $fixtureScripts 'New-SweArtifact.ps1') -InputPath $artifactInputPath -OutputPath (Join-Path $consumer 'incomplete.md') } 'Incomplete Compact template cannot waive required architecture concerns'

$recoveryInputPath = Join-Path $fixtureRoot 'recovery-input.json'
$recoveryPath = Join-Path $fixtureRoot 'RECOVERY.md'
$recoveryInput = @{
    schema_version = 1
    artifacts = @(@{ path = $legacy; sha256 = ('0' * 64) })
    receipts = @(@{ path = (Join-Path $unavailable.result_directory 'receipt.json') })
    handles = @('same-existing-assignment-handle')
    policy_locator = 'owner-adoption-decision'
    cycle_history_locator = 'existing-two-cycle-history'
    next_action = 'Resolve blocked check, preserving existing assignment and review history.'
}
Write-Json $recoveryInputPath $recoveryInput
$recoveryReport = (& $artifactHelper -Mode Recovery -InputPath $recoveryInputPath -OutputPath $recoveryPath) | ConvertFrom-Json
Assert-True (-not $recoveryReport.trusted_for_resume -and $recoveryReport.conflicts.Count -gt 0) 'Recovery detects stale fingerprints and requires live verification'
$recoveryText = Get-Content -Raw -LiteralPath $recoveryPath
Assert-True ($recoveryText -match 'Blocked' -and $recoveryText -match 'existing-two-cycle-history' -and $recoveryText -match 'same-existing-assignment-handle') 'Recovery retains blocked observations and durable cycle/assignment locators'
Assert-True ((Get-FileHash -LiteralPath $legacy).Hash -eq $legacyHash) 'Recovery never rewrites accepted legacy input'

$eligibilityHelper = Join-Path $PluginRoot 'scripts\Get-SweEligibility.ps1'
Assert-True (Test-Path -LiteralPath $eligibilityHelper -PathType Leaf) 'Runtime eligibility audit is available'
function New-Decision([string]$Id, [string]$Status = 'Accepted', [string]$Approver = 'independent-reviewer', [string]$Extra = '') {
    $path = Join-Path $portfolio ($Id + '.md')
    $text = "---`nid: " + '"' + $Id + '"' + "`nstatus: " + '"' + $Status + '"' + "`n---`n## Approval Record`n| Author | fixture-author |`n| Approver | $Approver |`n| Mode | auto-approve |`n| Decision | $Status |`n$Extra`n"
    [IO.File]::WriteAllText($path, $text)
    return @{ repository = $portfolio; path = ($Id + '.md'); artifact_id = $Id; sha256 = (Get-FileHash -LiteralPath $path).Hash }
}
$feature = New-Decision 'FEATURE-001'
$plan = New-Decision 'PLAN-001'
$architecture = New-Decision 'ARCH-001'
$architecturePath = Join-Path $portfolio 'ARCH-001.md'
[IO.File]::WriteAllText($architecturePath, ((Get-Content -Raw -LiteralPath $architecturePath).Replace('status: "Accepted"', 'status: "Target"')))
$architecture.sha256 = (Get-FileHash -LiteralPath $architecturePath).Hash
$design = New-Decision 'DESIGN-001'
$adoption = New-Decision 'ADOPTION-001' 'Accepted' 'repository-owner' ("| Approver kind | Human |`nadoption_repository: " + $consumer + "`napproval_policy: risk-based`nowner_authorized: true")
$portfolioAdoption = New-Decision 'ADOPTION-PORTFOLIO' 'Accepted' 'portfolio-owner' ("| Approver kind | Human |`nadoption_repository: " + $portfolio + "`napproval_policy: risk-based`nowner_authorized: true")
$cycleHistory = New-Decision 'CYCLES-001' 'Draft' 'independent-reviewer' "consumed_cycles: 0`nunresolved: false"
$majorApproval = New-Decision 'MAJOR-001' 'Accepted' 'named-human' '| Approver kind | Human |'
function New-Packet {
    return @{
        schema = 'swe-eligibility/v1'; assignment_id = 'ASSIGN-003'; repository = $consumer; phase = 'Implementation'
        feature = $feature; plan = $plan; architecture = $architecture; design = $design; policy_adoption = $adoption; approval_policies = @($portfolioAdoption); epic_id = 'EPIC-001'
        risk = @{ class = 'Minimal'; rationale = 'Isolated reversible work'; isolated = $true; reversible = $true; reviewed_deferral = $true; public_contract = $false; cross_solution = $false; security = $false; persistence = $false; concurrency = $false; operational = $false; mandatory_early_checks = $false }
        dependencies = @(); reviewed_independence = $true; behavior_consumers = @(); review = @{ consumed_cycles = 0; cycle_history = $cycleHistory }
    }
}
function Audit($Packet) {
    $path = Join-Path $fixtureRoot 'eligibility-input.json'; Write-Json $path $Packet
    return & $eligibilityHelper -InputPath $path
}
$packet = New-Packet
$ordinary = Audit $packet
Assert-True ($ordinary.eligible -and $ordinary.deferral_eligible -and -not $ordinary.grants_acceptance) 'Independent Minimal assignment proceeds while unrelated Plans wait'
Assert-True ((Get-Content -Raw -LiteralPath $architecturePath) -match 'status: "Target"' -and $ordinary.eligible) 'Approved Target architecture is a valid ordinary entry gate'
$packet.run_authorization = $packet.policy_adoption; $packet.Remove('policy_adoption')
Assert-True ((Audit $packet).deferral_eligible) 'Explicit owner run authorization can authorize Minimal deferral'
$packet.phase = 'Design'; $packet.Remove('design')
Assert-True ((Audit $packet).eligible) 'Design dispatch precedes local Design approval'
$packet.phase = 'Implementation'
Assert-True (-not (Audit $packet).eligible) 'Coding still requires accepted local Design'
$packet = New-Packet; $packet.phase = 'FeatureCompletion'; $packet.implementation_complete = $true; $packet.pending_checks = @('deferred')
Assert-True (-not (Audit $packet).eligible) 'Implementation-complete with deferred checks never means accepted delivery'
$packet = New-Packet; $packet.behavior_consumers = @('ASSIGN-002')
Assert-True (-not (Audit $packet).deferral_eligible) 'A new prerequisite consumer revokes deferral'
foreach ($flag in @('public_contract','cross_solution','security','persistence','concurrency','operational','mandatory_early_checks')) {
    $packet = New-Packet; $packet.risk[$flag] = $true; $packet.major_approval = $majorApproval
    Assert-True (-not (Audit $packet).deferral_eligible) "A Minimal label cannot bypass early risk: $flag"
}
$packet = New-Packet; $packet.Remove('policy_adoption'); $packet.prototype_mode = $true
Assert-True (-not (Audit $packet).deferral_eligible) 'Prototype state and package installation cannot silently adopt V3 policy'
$packet = New-Packet; $packet.review.consumed_cycles = 2
$packet.review.cycle_history = New-Decision 'CYCLES-002' 'Draft' 'independent-reviewer' "consumed_cycles: 2`nunresolved: true"
Assert-True (-not (Audit $packet).eligible) 'Resume preserves exhausted two-cycle limit'
$packet.review.human_disposition = $majorApproval
Assert-True ((Audit $packet).eligible) 'Recorded human disposition can release exhausted review gate'
$packet.review.Remove('human_disposition'); $packet.review.consumed_cycles = 0
Assert-True (-not (Audit $packet).eligible) 'Renaming or resuming cannot reset durable consumed repair cycles'
$packet.review.consumed_cycles = 2
$packet.review.cycle_history = New-Decision 'CYCLES-003' 'Draft' 'independent-reviewer' "consumed_cycles: 2`nunresolved: false"
Assert-True ((Audit $packet).eligible) 'A successful second permitted review can proceed without inventing another cycle'
$packet = New-Packet; $packet.reviewed_independence = $false
Assert-True (-not (Audit $packet).eligible) 'Missing dependency knowledge blocks affected work'
$packet = New-Packet
$packet.dependencies = @(@{ assignment_id = 'ASSIGN-001'; requirement = 'ValidatedBehavior'; entry_phase = 'Implementation'; criteria = @('FEATURE-001/AC-001'); cycle_free = $true; behavior = @{ validation = $feature; receipt = (Join-Path $unavailable.result_directory 'receipt.json'); generation = $unavailable.before.digest } })
Assert-True (-not (Audit $packet).eligible) 'Deferred or unavailable producer cannot satisfy validated behavior prerequisite'
$stableReceipt = Invoke-Receipt (New-Request)
$receiptPath = Join-Path $stableReceipt.result_directory 'receipt.json'
$receiptHash = (Get-FileHash -LiteralPath $receiptPath).Hash
$validation = New-Decision 'VALIDATION-001' 'Accepted' 'independent-validator' ($receiptPath + "`n" + $receiptHash + "`nFEATURE-001/AC-001`nFEATURE-003/AC-001")
$packet.dependencies[0].behavior = @{ validation = $validation; receipt = $receiptPath; receipt_sha256 = $receiptHash; generation = $stableReceipt.before.digest }
Assert-True ((Audit $packet).eligible) 'Consumer starts after independent accepted producer evidence for current generation'
$packet.dependencies[0].criteria = @('FEATURE-099/AC-999')
Assert-True (-not (Audit $packet).eligible) 'Passing unrelated criteria cannot satisfy a consumed prerequisite'
$packet.dependencies[0].criteria = @('FEATURE-001/AC-001')
$packet.phase = 'EpicAcceptance'; $packet.implementation_complete = $true; $packet.pending_checks = @(); $packet.delivery = $packet.dependencies[0].behavior
$packet.criteria = @('FEATURE-001/AC-001','FEATURE-003/AC-001')
$packet.assignments_complete = $true; $packet.architecture_reconciled = $true; $packet.portfolio_validation = $validation
Assert-True ((Audit $packet).eligible) 'Epic gate permits completion only after deferred checks and independent decisions drain'
$packet.assignments_complete = $false
Assert-True (-not (Audit $packet).eligible) 'Missing assignment prevents final Epic acceptance'
$packet = New-Packet; $packet.Remove('policy_adoption'); $packet.Remove('approval_policies')
Assert-True (-not (Audit $packet).eligible) 'Independent agent decisions do not replace default human approval without adoption'
$packet = New-Packet; $packet.Remove('approval_policies')
Assert-True (-not (Audit $packet).eligible) 'A child standing policy does not authorize upstream portfolio decisions'
$packet = New-Packet; $packet.named_approvers = @{ 'FEATURE-001' = 'specifically-named-reviewer' }
Assert-True (-not (Audit $packet).eligible) 'Standing policy cannot replace an explicitly named approver'
$packet = New-Packet
$packet.dependencies = @(@{ assignment_id = 'ASSIGN-001'; requirement = 'ValidatedBehavior'; entry_phase = 'Implementation'; criteria = @('FEATURE-001/AC-001'); cycle_free = $true; behavior = @{ validation = $validation; receipt = $receiptPath; receipt_sha256 = $receiptHash; generation = $stableReceipt.before.digest } })
[IO.File]::WriteAllText((Join-Path $producer 'src\added-after-review.txt'), 'new input')
Assert-True (-not (Audit $packet).eligible) 'Added source file invalidates previously accepted behavioral evidence'
[IO.File]::AppendAllText((Join-Path $portfolio 'PLAN-001.md'), 'changed during review')
$packet = New-Packet
Assert-True (-not (Audit $packet).eligible) 'Changed decision bytes invalidate approval correspondence'

Write-Output "V3 behavioral rehearsal passed $assertions assertions; attributable native receipts retained at $fixtureRoot"
