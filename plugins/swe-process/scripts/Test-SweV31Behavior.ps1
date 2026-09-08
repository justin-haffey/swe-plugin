[CmdletBinding()]
param([string]$ExecutorSession = $env:SWE_TEST_RUNNER_SESSION_ID)
$ErrorActionPreference = 'Stop'
if (-not $ExecutorSession) { throw 'Run in the actual Luna/medium tester session and set SWE_TEST_RUNNER_SESSION_ID.' }
$plugin = Split-Path -Parent $PSScriptRoot
$scratch = Join-Path ([IO.Path]::GetTempPath()) ('swe-v31-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($scratch)
$count = 0
function Check([bool]$Value, [string]$Message) { if (-not $Value) { throw "V3.1 fixture: $Message; retained at $scratch" }; $script:count++ }
function Json([string]$Path, $Value) { [IO.File]::WriteAllText($Path, ($Value | ConvertTo-Json -Depth 60)) }
function Reject([scriptblock]$Action, [string]$Message) { $failed = $false; try { $null = & $Action } catch { $failed = $true }; Check $failed $Message }
function Artifact([string]$Name, [string]$Body) {
    $path = Join-Path $scratch "$Name.md"
    [IO.File]::WriteAllText($path, "---`nid: $Name`nstatus: Accepted`n---`n| Author | fixture-author |`n| Approver | fixture-human |`n| Mode | human |`n| Decision | Accepted |`n$Body`n")
    return @{ path = "$Name.md" }
}
$feature = Artifact 'FEATURE-001' ''
$architecture = Artifact 'ARCH-001' ''
$history = Artifact 'CYCLES-001' "consumed_cycles: 2`nunresolved: false"
$risk = @{ class = 'Standard'; rationale = 'Explicit fixture findings'; isolated = $true; reversible = $true; reviewed_deferral = $false; mandatory_early_checks = $false; public_contract = $false; cross_solution = $false; security = $false; persistence = $false; concurrency = $false; operational = $false }
$findings = @{ assignment_id = 'CORE-001'; risk = $risk; dependencies = @(); reviewed_independence = $true; behavior_consumers = @(); review = @{ cycle_history = $history } }
$fence = '```'
$plan = Artifact 'PLAN-001' ($fence + "swe-eligibility`n" + ($findings | ConvertTo-Json -Depth 15) + "`n" + $fence)
$source = @{ schema = 'swe-packet-source/v1'; repository = $scratch; assignment_id = 'CORE-001'; phase = 'Design'; findings_artifact = $plan; artifacts = @{ feature = $feature; plan = $plan; architecture = $architecture } }
$sourcePath = Join-Path $scratch 'source.json'; Json $sourcePath $source
$builder = Join-Path $PSScriptRoot 'Get-SweEligibilityPacket.ps1'
$built = (& $builder -InputPath $sourcePath) | ConvertFrom-Json
Check ($built.ready_for_audit -and $built.unresolved.Count -eq 0 -and -not $built.grants_acceptance -and $built.writes -eq 0) 'builder derives mechanical fields without acceptance/writes'
Check ($built.packet.review.consumed_cycles -eq 2 -and $built.packet.plan.artifact_id -eq 'PLAN-001' -and $built.packet.plan.sha256.Length -eq 64) 'canonical identity, hash and cycle count derived'
Check ((& $builder -InputPath $sourcePath) -ceq ($built | ConvertTo-Json -Depth 60)) 'deterministic serialized packet'
$packetPath = Join-Path $scratch 'packet.json'; Json $packetPath $built.packet
$audit = & (Join-Path $PSScriptRoot 'Get-SweEligibility.ps1') -InputPath $packetPath
Check ($audit.eligible -and -not $audit.grants_acceptance) 'generated packet passes actual existing audit'
$source.findings_artifact = $null; Json $sourcePath $source
$unknown = (& $builder -InputPath $sourcePath) | ConvertFrom-Json
Check (-not $unknown.ready_for_audit -and $unknown.unresolved.Count -gt 0) 'missing semantics remain unresolved'
$source.findings_artifact = $plan; $source.assignment_id = 'WRONG'; Json $sourcePath $source
Reject { & $builder -InputPath $sourcePath } 'wrong assignment rejected'
$source.assignment_id = 'CORE-001'; $source.artifacts.feature = @{ path = '../escape.md' }; Json $sourcePath $source
$escape = (& $builder -InputPath $sourcePath) | ConvertFrom-Json
Check (-not $escape.ready_for_audit) 'escaping artifact unresolved'
$source.artifacts.feature = $built.packet.feature
[IO.File]::AppendAllText((Join-Path $scratch 'FEATURE-001.md'), 'changed')
Json $sourcePath $source
$stale = (& $builder -InputPath $sourcePath) | ConvertFrom-Json
Check (-not $stale.ready_for_audit) 'previously frozen artifact never silently refreshed'
Check (-not (& (Join-Path $PSScriptRoot 'Get-SweEligibility.ps1') -InputPath $packetPath).eligible) 'shared audit also rejects changed bytes'
$findings.feature = $architecture
$plan = Artifact 'PLAN-001' ($fence + "swe-eligibility`n" + ($findings | ConvertTo-Json -Depth 15) + "`n" + $fence)
$source.findings_artifact = $plan; $source.artifacts.feature = $feature; Json $sourcePath $source
$contradiction = (& $builder -InputPath $sourcePath) | ConvertFrom-Json
Check (-not $contradiction.ready_for_audit -and ($contradiction.unresolved -join ' ') -match 'conflicts') 'input addresses cannot override canonical findings locators'

# Adoption uses a disposable destination. Fixture decisions/dispatch text are explicitly
# test data; only the separate real host forward-test can establish live routing.
$destination = Join-Path $scratch 'destination'; [void][IO.Directory]::CreateDirectory($destination)
$proposed = Join-Path $plugin 'skills/swe-scaffold/references/solution'
Copy-Item -Path (Join-Path $proposed '*') -Destination $destination -Recurse -Force
# Copy hidden .codex explicitly on hosts whose wildcard provider omits it.
if (-not (Test-Path (Join-Path $destination '.codex'))) { Copy-Item -LiteralPath (Join-Path $proposed '.codex') -Destination $destination -Recurse -Force }
$preflight = Join-Path $PSScriptRoot 'Get-SweAdoptionPreflight.ps1'
$blocked = (& $preflight -Destination $destination -Kind solution -Baseline $proposed) | ConvertFrom-Json
Check ($blocked.readiness -eq 'Blocked' -and $blocked.policy_compatibility -eq 'ReviewRequired' -and $blocked.host_capability -eq 'Unverified') 'missing policy and host evidence block adoption'
Check ($blocked.destination_writes -eq 0 -and -not $blocked.policy_activated -and $blocked.proposal.DestinationWrites -eq 0) 'preflight is read-only'
$gov = Join-Path $destination 'AGENTS.md'
$govHash = (Get-FileHash -LiteralPath $gov).Hash
$version = (Get-Content -Raw (Join-Path $plugin '.codex-plugin/plugin.json') | ConvertFrom-Json).version
$policyText = "---`nid: ADOPTION-FIXTURE`nstatus: Accepted`n---`nadoption_repository: $destination`ntarget_version: $version`ngovernance_sha256: $govHash`ncompatibility: Compatible`n| Author | fixture-author |`n| Approver | fixture-human |`n| Mode | human |`n| Decision | Accepted |`n"
[IO.File]::WriteAllText((Join-Path $destination 'ADOPTION.md'), $policyText)
$config = Join-Path $destination '.codex/config.toml'; $role = Join-Path $destination '.codex/agents/swe/test-runner.toml'; $skill = Join-Path $plugin 'skills/swe-test/SKILL.md'
$shell = (Get-Process -Id $PID).Path
$smoke = Join-Path $destination 'smoke.ps1'; [IO.File]::WriteAllText($smoke, 'Write-Output "V31 smoke"')
$request = @{
    schema = 'swe-check-request/v1'; execution_role = 'test-runner'; executor = @{ role = 'test-runner'; model = 'gpt-5.6-luna'; reasoning_effort = 'medium'; session_id = $ExecutorSession }
    repository = $destination; assignment = @{ repository = $destination; artifact_id = 'HOST'; path = 'ADOPTION.md' }; criteria = @('HOST/AC-001')
    scope = @{ source = @('smoke.ps1', $skill); tests = @(); configuration = @('.codex/config.toml','.codex/agents/swe/test-runner.toml'); fixtures = @(); dependencies = @() }
    runtime = @{ identity = 'Current tester PowerShell'; paths = @($shell) }; scope_rationale = 'Isolated native fixture with no separate tests, fixtures or dependencies.'
    risk = 'Standard'; timing = 'Preflight'; prerequisites = @(); shared_outputs = @(); result_directory = (Join-Path $scratch 'receipts')
    checks = @(@{ id = 'smoke'; executable = $shell; arguments = @('-NoProfile','-File',$smoke); working_directory = '.'; timeout_seconds = 20; criteria = @('HOST/AC-001') })
}
$requestPath = Join-Path $scratch 'request.json'; Json $requestPath $request
$receiptPath = & (Join-Path $PSScriptRoot 'Invoke-SweChecks.ps1') -RequestPath $requestPath
function Bound([string]$Path) { return @{ path = $Path; sha256 = (Get-FileHash -LiteralPath $Path).Hash } }
$dispatch = Join-Path $scratch 'fixture-dispatch.txt'; [IO.File]::WriteAllText($dispatch, 'FIXTURE DATA: supplied dispatch provenance mechanics, not live host attestation.')
$hostPacket = @{ schema = 'swe-host-preflight/v1'; repository = $destination; role = 'test-runner'; model = 'gpt-5.6-luna'; reasoning_effort = 'medium'; session_id = $ExecutorSession; route = 'ConfiguredFallback'; config_file = (Bound $config); role_file = (Bound $role); skill_file = (Bound $skill); dispatch_evidence = (Bound $dispatch); receipt = (Bound $receiptPath) }
$hostPath = Join-Path $scratch 'host.json'; Json $hostPath $hostPacket
$ready = (& $preflight -Destination $destination -Kind solution -Baseline $proposed -PolicyPath 'ADOPTION.md' -HostEvidencePath $hostPath) | ConvertFrom-Json
Check ($ready.readiness -eq 'ReadyForReview' -and $ready.host_capability -eq 'AttestedSmokePassed') ('complete bound fixture preflight: ' + ($ready.reasons -join '; '))
Check (-not $ready.policy_activated) 'complete preflight still cannot adopt'
[IO.File]::WriteAllText((Join-Path $destination 'ADOPTION.md'), $policyText.Replace('status: Accepted','status: Draft') + "`nstatus: Accepted`n")
$draftPolicy = (& $preflight -Destination $destination -Kind solution -Baseline $proposed -PolicyPath 'ADOPTION.md' -HostEvidencePath $hostPath) | ConvertFrom-Json
Check ($draftPolicy.policy_compatibility -eq 'ReviewRequired') 'Draft metadata cannot be overridden by body text'
[IO.File]::WriteAllText((Join-Path $destination 'ADOPTION.md'), $policyText)
$hostPacket.model = 'wrong-model'; Json $hostPath $hostPacket
Check ((& $preflight -Destination $destination -Kind solution -Baseline $proposed -PolicyPath 'ADOPTION.md' -HostEvidencePath $hostPath | ConvertFrom-Json).readiness -eq 'Blocked') 'wrong host model rejected'
$hostPacket.model = 'gpt-5.6-luna'; Json $hostPath $hostPacket
[IO.File]::AppendAllText($smoke, "`n# changed")
$staleSmoke = (& $preflight -Destination $destination -Kind solution -Baseline $proposed -PolicyPath 'ADOPTION.md' -HostEvidencePath $hostPath) | ConvertFrom-Json
Check ($staleSmoke.host_capability -eq 'Unverified') 'changed runtime/source generation blocks smoke reuse'
[IO.File]::AppendAllText($gov, "`n# customization")
$conflict = (& $preflight -Destination $destination -Kind solution -Baseline $proposed -PolicyPath 'ADOPTION.md') | ConvertFrom-Json
Check ($conflict.policy_compatibility -eq 'ReviewRequired') 'changed governance invalidates compatibility review'
Check ((Get-FileHash -LiteralPath $gov).Hash -ne $govHash) 'customization is preserved, never overwritten'
Write-Output "V3.1 behavior passed $count assertions; fixtures and receipt retained at $scratch"
