[CmdletBinding()]
param([Parameter(Mandatory = $true)][string]$RequestPath, [switch]$FingerprintOnly)

# This helper records observations. The invoking tester owns command authorization;
# the independent validator owns adequacy and acceptance.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0
$request = Get-Content -LiteralPath $RequestPath -Raw | ConvertFrom-Json
function Get-Value($Object, [string]$Name, $Default = $null) {
    if ($null -ne $Object -and $null -ne $Object.PSObject.Properties[$Name]) { return $Object.$Name }
    return $Default
}
function Get-Digest([string]$Text) {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)))).Replace('-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}
function Resolve-PathName([string]$Path, [string]$Base) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $Base $Path))
}
function Get-TreeFingerprint {
    param([AllowNull()][AllowEmptyCollection()][string[]]$Paths, [string]$Base)
    $items = @()
    foreach ($path in @($Paths)) {
        # An empty JSON array can travel through a PowerShell function as null.
        # Never resolve that absence as the repository's current directory.
        if ([string]::IsNullOrWhiteSpace($path)) { continue }
        $absolute = Resolve-PathName ([string]$path) $Base
        if (-not (Test-Path -LiteralPath $absolute)) {
            $items += [ordered]@{ path = $absolute; digest = $null; state = 'Missing' }; continue
        }
        $entry = Get-Item -LiteralPath $absolute -Force
        if ($entry.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Fingerprint scope contains a reparse point: $absolute" }
        $files = @(if ($entry.PSIsContainer) { Get-ChildItem -LiteralPath $absolute -Recurse -Force } else { $entry })
        # Reparse points are rejected, rather than silently omitting part of the closure.
        foreach ($file in $files) {
            if ($file.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Fingerprint scope contains a reparse point: $($file.FullName)" }
            if (-not $file.PSIsContainer -and $file.Name -ne '.swe-check.lock') { $items += [ordered]@{ path = $file.FullName; digest = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant(); state = 'Present' } }
        }
        if ($entry.PSIsContainer -and $files.Count -eq 0) { $items += [ordered]@{ path = $absolute; digest = Get-Digest ''; state = 'EmptyDirectory' } }
    }
    $items = @($items | Sort-Object { $_.path } -Unique)
    return [ordered]@{ digest = Get-Digest (ConvertTo-Json -InputObject $items -Depth 10 -Compress); files = $items }
}
function Get-Snapshot {
    $snapshot = [ordered]@{}
    foreach ($category in @('source','tests','configuration','fixtures','dependencies')) {
        $snapshot[$category] = Get-TreeFingerprint (Get-Value $request.scope $category @()) $repository
    }
    $runtimePaths = @(Get-Value $request.runtime 'paths' @())
    foreach ($check in @($request.checks)) {
        $exe = Get-Command ([string]$check.executable) -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -ne $exe) { $runtimePaths += $exe.Source }
    }
    $environment = [ordered]@{}
    foreach ($key in @(Get-Value $request.runtime 'environment' @()) | Sort-Object -Unique) { $environment[$key] = Get-Digest (ConvertTo-Json -InputObject ([Environment]::GetEnvironmentVariable($key)) -Compress) }
    $snapshot.runtime = [ordered]@{ identity = $request.runtime.identity; powershell = $PSVersionTable.PSVersion.ToString(); os = [Environment]::OSVersion.ToString(); path_digest = Get-Digest ([string]$env:PATH); environment = $environment; files = Get-TreeFingerprint $runtimePaths $repository }
    $snapshot.digest = Get-Digest (ConvertTo-Json -InputObject $snapshot -Depth 20 -Compress)
    return $snapshot
}
function Quote-NativeArgument([string]$Value) {
    # Windows CommandLineToArgvW rules; no command shell is inserted.
    return '"' + [regex]::Replace([regex]::Replace($Value, '(\\*)"', '$1$1\"'), '(\\+)$', '$1$1') + '"'
}
function Write-NewText([string]$Path, [string]$Text) {
    $stream = [IO.File]::Open($Path, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::Read)
    try { $bytes = [Text.Encoding]::UTF8.GetBytes($Text); $stream.Write($bytes, 0, $bytes.Length) }
    finally { $stream.Dispose() }
}
function Assert-Object($Value, [string[]]$Required, [string[]]$Allowed, [string]$Label) {
    if ($Value -isnot [pscustomobject]) { throw "$Label must be a JSON object." }
    foreach ($key in $Required) { if ($null -eq $Value.PSObject.Properties[$key]) { throw "$Label is missing $key." } }
    foreach ($property in $Value.PSObject.Properties) { if ($property.Name -cnotin $Allowed) { throw "$Label has unknown field $($property.Name)." } }
}
function Assert-String($Value, [string]$Label, [bool]$AllowEmpty = $false) {
    if ($Value -isnot [string] -or (-not $AllowEmpty -and [string]::IsNullOrWhiteSpace($Value))) { throw "$Label must be a nonblank JSON string." }
}
function Assert-Array($Value, [string]$Label, [switch]$Strings) {
    if ($Value -isnot [array]) { throw "$Label must be a JSON array." }
    if ($Strings) { foreach ($item in $Value) { Assert-String $item $Label $true } }
}
function Assert-RequestShape {
    $fields = @('schema','repository','assignment','criteria','scope','runtime','checks','risk','timing','prerequisites','result_directory','shared_outputs','execution_role','executor')
    Assert-Object $request $fields ($fields + @('scope_rationale','expected_fingerprint')) 'request'
    foreach ($field in @('schema','repository','risk','timing','result_directory','execution_role')) { Assert-String $request.$field "request.$field" }
    Assert-Object $request.assignment @('repository','artifact_id','path') @('repository','artifact_id','path','revision') 'assignment'
    foreach ($property in $request.assignment.PSObject.Properties) { Assert-String $property.Value "assignment.$($property.Name)" }
    Assert-Object $request.executor @('role','model','reasoning_effort','session_id') @('role','model','reasoning_effort','session_id') 'executor'
    foreach ($property in $request.executor.PSObject.Properties) { Assert-String $property.Value "executor.$($property.Name)" }
    Assert-Array $request.criteria 'criteria' -Strings
    $categories = @('source','tests','configuration','fixtures','dependencies')
    Assert-Object $request.scope $categories $categories 'scope'
    foreach ($category in $categories) {
        Assert-Array $request.scope.$category "scope.$category" -Strings
        foreach ($path in $request.scope.$category) { Assert-String $path "scope.$category path" }
    }
    Assert-Object $request.runtime @('identity','paths') @('identity','paths','environment') 'runtime'
    Assert-String $request.runtime.identity 'runtime.identity'
    Assert-Array $request.runtime.paths 'runtime.paths' -Strings
    foreach ($path in $request.runtime.paths) { Assert-String $path 'runtime path' }
    if ($null -ne $request.runtime.PSObject.Properties['environment']) { Assert-Array $request.runtime.environment 'runtime.environment' -Strings; foreach ($key in $request.runtime.environment) { Assert-String $key 'environment key' } }
    Assert-Array $request.prerequisites 'prerequisites'
    foreach ($prerequisite in $request.prerequisites) { if ($prerequisite -isnot [pscustomobject]) { throw 'Each prerequisite must be a JSON object.' } }
    Assert-Array $request.shared_outputs 'shared_outputs'
    foreach ($output in $request.shared_outputs) { Assert-Object $output @('path','generation') @('path','generation') 'shared output'; Assert-String $output.path 'output.path'; Assert-String $output.generation 'output.generation' }
    foreach ($optional in @('scope_rationale','expected_fingerprint')) { if ($null -ne $request.PSObject.Properties[$optional]) { Assert-String $request.$optional $optional } }
    if ($null -ne $request.PSObject.Properties['expected_fingerprint'] -and $request.expected_fingerprint -cnotmatch '^[a-f0-9]{64}$') { throw 'expected_fingerprint must be a SHA256 digest.' }
    Assert-Array $request.checks 'checks'
    foreach ($check in $request.checks) {
        $checkFields = @('id','executable','arguments','working_directory','timeout_seconds','criteria')
        Assert-Object $check $checkFields ($checkFields + @('observation_path','cases','blocked_reason','replay_safe')) 'check'
        foreach ($field in @('id','executable','working_directory')) { Assert-String $check.$field "check.$field" }
        Assert-Array $check.arguments 'check.arguments' -Strings
        Assert-Array $check.criteria 'check.criteria' -Strings
        if (($check.timeout_seconds -isnot [int] -and $check.timeout_seconds -isnot [long]) -or $check.timeout_seconds -lt 1 -or $check.timeout_seconds -gt 3600) { throw 'timeout_seconds must be an integer from 1 through 3600.' }
        foreach ($optional in @('observation_path','blocked_reason')) { if ($null -ne $check.PSObject.Properties[$optional]) { Assert-String $check.$optional "check.$optional" } }
        if ($null -ne $check.PSObject.Properties['replay_safe'] -and $check.replay_safe -isnot [bool]) { throw 'replay_safe must be a JSON boolean.' }
        if ($null -ne $check.PSObject.Properties['cases']) {
            Assert-Array $check.cases 'check.cases'
            foreach ($case in $check.cases) { $caseFields = @('id','participant','operation','fixture','expected'); Assert-Object $case $caseFields $caseFields 'case'; foreach ($field in $caseFields) { Assert-String $case.$field "case.$field" } }
        }
    }
}

Assert-RequestShape
if ($request.schema -ne 'swe-check-request/v1') { throw 'Unsupported request schema.' }
foreach ($field in @('repository','assignment','criteria','scope','runtime','checks','risk','timing','prerequisites','result_directory','shared_outputs','execution_role','executor')) {
    if ($null -eq $request.PSObject.Properties[$field]) { throw "Missing request field: $field" }
}
if ($request.execution_role -ne 'test-runner' -or $request.executor.role -ne 'test-runner' -or $request.executor.model -ne 'gpt-5.6-luna' -or $request.executor.reasoning_effort -ne 'medium' -or -not $request.executor.session_id) { throw 'The request must identify the actual Luna/medium test-runner session.' }
$repository = Resolve-PathName $request.repository (Get-Location).Path
if (-not (Test-Path -LiteralPath $repository -PathType Container)) { throw 'Exact repository directory is unavailable.' }
if ($FingerprintOnly) {
    if ($request.risk -cnotin @('Minimal','Standard','Major')) { throw 'Risk must be Minimal, Standard, or Major.' }
    foreach ($category in @('source','tests','configuration','fixtures','dependencies')) { if (@($request.scope.$category).Count -eq 0 -and [string]::IsNullOrWhiteSpace([string](Get-Value $request 'scope_rationale'))) { throw 'Empty scope categories require scope_rationale.' } }
    Write-Output (ConvertTo-Json (Get-Snapshot) -Depth 30); return
}
$resultRoot = Resolve-PathName $request.result_directory $repository
$executionId = [Guid]::NewGuid().ToString()
$resultDirectory = Join-Path $resultRoot $executionId
[void][IO.Directory]::CreateDirectory($resultDirectory)
$started = [DateTime]::UtcNow.ToString('o')
$receipt = [ordered]@{ schema = 'swe-check-receipt/v1'; execution_id = $executionId; request_digest = Get-Digest (ConvertTo-Json $request -Depth 30 -Compress); repository = $repository; assignment = $request.assignment; executor = $request.executor; started_utc = $started; finished_utc = $null; risk = $request.risk; timing = $request.timing; prerequisites = $request.prerequisites; shared_outputs = $request.shared_outputs; before = $null; after = $null; changed_during_run = $false; reusable = $false; outcome = 'Blocked'; attempts = @(); missing_coverage = @(); blockers = @(); result_directory = $resultDirectory }
Write-NewText (Join-Path $resultDirectory 'request.json') (ConvertTo-Json $request -Depth 30)
$receipt.request = [ordered]@{ path = (Join-Path $resultDirectory 'request.json'); digest = (Get-FileHash -LiteralPath (Join-Path $resultDirectory 'request.json') -Algorithm SHA256).Hash.ToLowerInvariant() }
$leases = @()
$pending = @($request.criteria)
try {
    if ($request.risk -cnotin @('Minimal','Standard','Major')) { throw 'Risk must be Minimal, Standard, or Major.' }
    foreach ($category in @('source','tests','configuration','fixtures','dependencies')) {
        if ($null -eq $request.scope.PSObject.Properties[$category]) { throw "Scope category must be explicit, including an empty array when justified: $category" }
        if (@($request.scope.$category).Count -eq 0 -and [string]::IsNullOrWhiteSpace([string](Get-Value $request 'scope_rationale'))) { throw "Empty $category scope requires scope_rationale; provenance is otherwise unknown." }
        foreach ($scopePath in @($request.scope.$category)) {
            $fullScope = (Resolve-PathName $scopePath $repository).TrimEnd('\','/')
            if ($resultDirectory.Equals($fullScope, [StringComparison]::OrdinalIgnoreCase) -or $resultDirectory.StartsWith($fullScope + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Result directory overlaps fingerprint inputs. Choose a separate result directory or narrower closure.' }
        }
    }
    $checkIds = @{}
    foreach ($check in @($request.checks)) {
        foreach ($field in @('id','executable','arguments','working_directory','timeout_seconds','criteria')) { if ($null -eq $check.PSObject.Properties[$field]) { throw "Check is missing $field" } }
        if ($check.id -notmatch '^[A-Za-z0-9._-]+$' -or $checkIds.ContainsKey($check.id)) { throw 'Check IDs must be unique safe file names.' }
        $checkIds[$check.id] = $true
        if ($check.timeout_seconds -lt 1 -or $check.timeout_seconds -gt 3600) { throw 'Each check timeout must be 1 through 3600 seconds.' }
        foreach ($criterion in @($check.criteria)) { if ($criterion -notin @($request.criteria)) { throw "Unknown criterion: $criterion" } }
    }
    if (@($request.checks).Count -eq 0) { throw 'No required checks were supplied.' }
    # The same absolute output path provides a cross-process mutex. Keep the file;
    # deleting a lock after releasing it could delete a successor owner's lock.
    foreach ($resource in @($request.shared_outputs | Sort-Object path)) {
        $resourcePath = Resolve-PathName $resource.path $repository
        if (-not (Test-Path -LiteralPath $resourcePath -PathType Container) -or -not $resource.generation) { throw "Shared output path/generation is unavailable: $resourcePath" }
        $lease = [IO.File]::Open((Join-Path $resourcePath '.swe-check.lock'), [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
        $leases += $lease
        $lease.SetLength(0)
        $owner = [Text.Encoding]::UTF8.GetBytes("$executionId $($request.executor.session_id)")
        $lease.Write($owner, 0, $owner.Length); $lease.Flush()
    }
    $receipt.before = Get-Snapshot
    foreach ($category in @('source','tests','configuration','fixtures','dependencies')) {
        if (@($receipt.before[$category].files | Where-Object { $_.state -eq 'Missing' }).Count -gt 0) { throw "Required $category inputs are missing." }
    }
    if (@($receipt.before.runtime.files.files | Where-Object { $_.state -eq 'Missing' }).Count -gt 0) { throw 'Required runtime inputs are missing.' }
    $expected = Get-Value $request 'expected_fingerprint'
    if ($expected -and $expected -ne $receipt.before.digest) { throw 'Expected source/runtime/dependency fingerprint is stale.' }
    foreach ($check in @($request.checks)) {
        $retry = 0
        do {
            $attemptId = "$($check.id)-$($retry + 1)"
            $stdoutPath = Join-Path $resultDirectory "$attemptId.stdout.log"
            $stderrPath = Join-Path $resultDirectory "$attemptId.stderr.log"
            $attempt = [ordered]@{ check_id = $check.id; attempt = $retry + 1; executable = $check.executable; arguments = @($check.arguments); working_directory = Resolve-PathName $check.working_directory $repository; criteria = @($check.criteria); started_utc = [DateTime]::UtcNow.ToString('o'); finished_utc = $null; timeout_seconds = $check.timeout_seconds; timed_out = $false; exit_code = $null; outcome = 'Blocked'; failure_excerpt = ''; launch_error = $null; transient_launch_failure = $false; stdout = $null; stderr = $null; counts = $null; cases = @(); observation = $null }
            $stdout = ''; $stderr = ''; $process = $null; $launched = $false
            try {
                $blockedReason = Get-Value $check 'blocked_reason'
                if ($blockedReason) { throw [InvalidOperationException]::new([string]$blockedReason) }
                if (-not (Test-Path -LiteralPath $attempt.working_directory -PathType Container)) { throw 'Working directory is unavailable.' }
                $command = Get-Command ([string]$check.executable) -CommandType Application -ErrorAction Stop | Select-Object -First 1
                $attempt.executable = $command.Source
                $process = New-Object Diagnostics.Process
                $process.StartInfo.FileName = $command.Source
                $process.StartInfo.WorkingDirectory = $attempt.working_directory
                $process.StartInfo.UseShellExecute = $false
                $process.StartInfo.CreateNoWindow = $true
                $process.StartInfo.RedirectStandardOutput = $true
                $process.StartInfo.RedirectStandardError = $true
                if ($null -ne $process.StartInfo.PSObject.Properties['ArgumentList']) {
                    foreach ($argument in @($check.arguments)) { [void]$process.StartInfo.ArgumentList.Add([string]$argument) }
                } else { $process.StartInfo.Arguments = (@($check.arguments | ForEach-Object { Quote-NativeArgument ([string]$_) }) -join ' ') }
                $observationPath = Get-Value $check 'observation_path'
                if ($observationPath) {
                    $observationPath = Resolve-PathName $observationPath $attempt.working_directory
                    if (Test-Path -LiteralPath $observationPath) { throw 'Observation output already exists; use a fresh per-execution path.' }
                }
                $launched = $process.Start()
                $stdoutTask = $process.StandardOutput.ReadToEndAsync()
                $stderrTask = $process.StandardError.ReadToEndAsync()
                if (-not $process.WaitForExit([int]$check.timeout_seconds * 1000)) {
                    $attempt.timed_out = $true
                    # On PowerShell 7 terminate the process tree; Windows PowerShell
                    # uses the native tree terminator, never an unrelated process name.
                    if ($null -ne $process.GetType().GetMethod('Kill', [type[]]@([bool]))) { $process.Kill($true) }
                    elseif ($env:OS -eq 'Windows_NT') { & taskkill.exe /PID $process.Id /T /F 2>&1 | Out-Null }
                    else { $process.Kill() }
                    [void]$process.WaitForExit(5000)
                    $attempt.failure_excerpt = 'Command exceeded its timeout.'
                }
                $outputComplete = $true
                if ($stdoutTask.Wait(5000)) { $stdout = $stdoutTask.Result } else { $stderr += 'stdout pipe did not close; output is incomplete.'; $outputComplete = $false }
                if ($stderrTask.Wait(5000)) { $stderr += $stderrTask.Result } else { $stderr += 'stderr pipe did not close; output is incomplete.'; $outputComplete = $false }
                if ($process.HasExited) { $attempt.exit_code = $process.ExitCode }
                if (-not $attempt.timed_out -and $outputComplete) {
                    if ($attempt.exit_code -eq 0) { $attempt.outcome = 'Passed' } else { $attempt.outcome = 'Failed' }
                }
                if ($observationPath -and (Test-Path -LiteralPath $observationPath -PathType Leaf)) {
                    $observationText = Get-Content -LiteralPath $observationPath -Raw
                    $observation = $observationText | ConvertFrom-Json
                    if ($observation -isnot [pscustomobject]) { throw 'Native observation must be a JSON object.' }
                    if ($null -ne $observation.PSObject.Properties['counts'] -and $observation.counts -isnot [pscustomobject]) { throw 'Observation counts must be a JSON object.' }
                    if ($null -ne $observation.PSObject.Properties['cases']) { Assert-Array $observation.cases 'observation.cases' }
                    $savedObservationPath = Join-Path $resultDirectory "$attemptId.observation.json"
                    Write-NewText $savedObservationPath $observationText
                    $attempt.observation = [ordered]@{ path = $savedObservationPath; digest = (Get-FileHash -LiteralPath $savedObservationPath -Algorithm SHA256).Hash.ToLowerInvariant() }
                    $attempt.counts = Get-Value $observation 'counts'
                    $attempt.cases = @(Get-Value $observation 'cases' @())
                } elseif ($observationPath) {
                    $receipt.missing_coverage += "$($check.id):observation"
                    if ($attempt.outcome -eq 'Passed') { $attempt.outcome = 'Blocked' }
                    $attempt.failure_excerpt = 'Requested native observation file was not produced.'
                }
                $requiredCases = @(Get-Value $check 'cases' @())
                foreach ($case in $requiredCases) {
                    $realized = @($attempt.cases | Where-Object { $_.id -ceq $case.id -and $_.participant -ceq $case.participant -and $_.operation -ceq $case.operation -and $_.fixture -ceq $case.fixture -and $_.expected -ceq $case.expected -and $_.actual -ceq $case.expected -and $_.outcome -ceq 'Passed' })
                    if ($realized.Count -ne 1) { $receipt.missing_coverage += "$($check.id):$($case.id)"; if ($attempt.outcome -eq 'Passed') { $attempt.outcome = 'Blocked' }; $attempt.failure_excerpt = 'Required concrete case observations are missing or disagree.' }
                }
            } catch {
                $attempt.outcome = 'Blocked'
                $attempt.launch_error = $_.Exception.Message
                $attempt.failure_excerpt = $_.Exception.Message
                # Only operating-system launch contention permits one retry. An
                # assertion failure, timeout, missing executable or parse error does not.
                $launchException = $_.Exception
                while ($null -ne $launchException.InnerException) { $launchException = $launchException.InnerException }
                $nativeError = Get-Value $launchException 'NativeErrorCode' -1
                $attempt.transient_launch_failure = (-not $launched -and $nativeError -in @(11,32,33))
            } finally {
                if ($null -ne $process) { $process.Dispose() }
                Write-NewText $stdoutPath $stdout
                Write-NewText $stderrPath $stderr
                $attempt.stdout = [ordered]@{ path = $stdoutPath; digest = (Get-FileHash -LiteralPath $stdoutPath -Algorithm SHA256).Hash.ToLowerInvariant() }
                $attempt.stderr = [ordered]@{ path = $stderrPath; digest = (Get-FileHash -LiteralPath $stderrPath -Algorithm SHA256).Hash.ToLowerInvariant() }
                if (-not $attempt.failure_excerpt -and $attempt.outcome -ne 'Passed') { $attempt.failure_excerpt = ($stderr + $stdout).Substring(0, [Math]::Min(1000, ($stderr + $stdout).Length)) }
                $attempt.finished_utc = [DateTime]::UtcNow.ToString('o')
                Write-NewText (Join-Path $resultDirectory "$attemptId.json") (ConvertTo-Json $attempt -Depth 25)
                $receipt.attempts += $attempt
            }
            $repeat = $attempt.transient_launch_failure -and $retry -eq 0 -and (Get-Value $check 'replay_safe' $false)
            $retry++
        } while ($repeat)
    }
} catch { $receipt.blockers += $_.Exception.Message }
finally {
    try {
        $receipt.after = Get-Snapshot
        if ($null -ne $receipt.before) { $receipt.changed_during_run = $receipt.before.digest -ne $receipt.after.digest }
    } catch { $receipt.blockers += "After fingerprint unavailable: $($_.Exception.Message)" }
    $lastAttempts = @($receipt.attempts | Group-Object check_id | ForEach-Object { $_.Group[-1] })
    $pending = @()
    foreach ($criterion in @($request.criteria)) {
        $requiredChecks = @($request.checks | Where-Object { $criterion -in @($_.criteria) })
        $passedChecks = @($lastAttempts | Where-Object { $criterion -in @($_.criteria) -and $_.outcome -eq 'Passed' })
        if ($requiredChecks.Count -eq 0 -or $passedChecks.Count -ne $requiredChecks.Count) { $pending += $criterion }
    }
    $receipt.missing_coverage = @(@($receipt.missing_coverage) + @($pending) | Sort-Object -Unique)
    if ($receipt.changed_during_run) { $receipt.blockers += 'Inputs changed during execution; affected checks require a fresh generation.' }
    if (@($lastAttempts | Where-Object { $_.outcome -eq 'Failed' }).Count -gt 0) { $receipt.outcome = 'Failed' }
    elseif ($receipt.blockers.Count -gt 0 -or $receipt.missing_coverage.Count -gt 0 -or @($lastAttempts | Where-Object { $_.outcome -ne 'Passed' }).Count -gt 0 -or $lastAttempts.Count -ne @($request.checks).Count) { $receipt.outcome = 'Blocked' }
    else { $receipt.outcome = 'Passed'; $receipt.reusable = $true }
    $receipt.finished_utc = [DateTime]::UtcNow.ToString('o')
    $receiptPath = Join-Path $resultDirectory 'receipt.json'
    try { Write-NewText $receiptPath (ConvertTo-Json $receipt -Depth 35) }
    finally { foreach ($lease in $leases) { $lease.Dispose() } }
}
Write-Output $receiptPath
