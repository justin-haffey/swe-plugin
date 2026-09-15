[CmdletBinding()]
param([switch]$Apply)

$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT' -or [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    throw 'This repair supports the current Windows user desktop installation only.'
}

$codexRoot = Join-Path $env:LOCALAPPDATA 'OpenAI\Codex'
$binRoot = Join-Path $codexRoot 'bin'
$launcherRoot = Join-Path $codexRoot 'launcher'
$userPathBefore = [Environment]::GetEnvironmentVariable('Path', 'User')
$machinePathBefore = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$candidates = @(if (Test-Path -LiteralPath $binRoot -PathType Container) {
    Get-ChildItem -LiteralPath $binRoot -Directory | ForEach-Object {
        $candidate = Join-Path $_.FullName 'codex.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { Get-Item -LiteralPath $candidate }
    } | Sort-Object @{ Expression = 'LastWriteTimeUtc'; Descending = $true }, FullName
})
$currentCommands = @(Get-Command codex -All -ErrorAction SilentlyContinue | Select-Object CommandType, Source, Definition)
$pathEntries = @()
if ($null -ne $userPathBefore) { $pathEntries = @($userPathBefore -split ';') }
$otherEntries = @($pathEntries | Where-Object {
    [Environment]::ExpandEnvironmentVariables($_.Trim().Trim('"')).TrimEnd('\') -ine $launcherRoot.TrimEnd('\')
})
$userPathAfter = (@($launcherRoot) + $otherEntries) -join ';'
$result = [ordered]@{
    Mode = $(if ($Apply) { 'Apply' } else { 'Inspect' })
    DesktopBinRoot = $binRoot
    CandidatePaths = @($candidates | ForEach-Object FullName)
    SelectedCli = $(if ($candidates.Count) { $candidates[0].FullName } else { $null })
    LauncherDirectory = $launcherRoot
    CurrentCommands = $currentCommands
    UserPathChangeNeeded = ($userPathBefore -cne $userPathAfter)
    ChangedFiles = @()
    BackupPath = $null
}
if (-not $Apply) { [pscustomobject]$result; return }
if ($candidates.Count -eq 0) { throw "No desktop Codex CLI found beneath '$binRoot'; no changes made." }

# Prepare every replacement before writing; unknown files belong to the user.
$fileChanges = @()
foreach ($name in @('codex.cmd', 'codex-launch.ps1')) {
    $source = Join-Path $PSScriptRoot $name
    $destination = Join-Path $launcherRoot $name
    $desired = [IO.File]::ReadAllText($source)
    $prior = $null
    if (Test-Path -LiteralPath $destination) {
        if (-not (Test-Path -LiteralPath $destination -PathType Leaf)) { throw "Launcher destination is not a file: $destination" }
        $prior = [IO.File]::ReadAllText($destination)
        if ($prior -notmatch '^(?:@rem |# )SWE codex-update managed launcher v1\r?\n') {
            throw "Unrecognized launcher file; inspect ownership before replacement: $destination"
        }
    }
    if ($prior -cne $desired) {
        $fileChanges += [pscustomobject]@{ Path = $destination; Before = $prior; After = $desired }
    }
}
if ($fileChanges.Count -eq 0 -and $userPathBefore -ceq $userPathAfter) {
    [pscustomobject]$result
    return
}
if ([Environment]::GetEnvironmentVariable('Path', 'User') -cne $userPathBefore) {
    throw 'User PATH changed during preparation. Inspect again before applying.'
}
[void][IO.Directory]::CreateDirectory($launcherRoot)
$backupPath = Join-Path $launcherRoot ('repair-before-' + [Guid]::NewGuid().ToString('N') + '.json')
$backup = [ordered]@{
    UserPath = $userPathBefore
    MachinePath = $machinePathBefore
    Files = @($fileChanges | Select-Object Path, Before)
}
[IO.File]::WriteAllText($backupPath, ($backup | ConvertTo-Json -Depth 6), [Text.UTF8Encoding]::new($false))
try {
    foreach ($change in $fileChanges) {
        $current = $null
        if (Test-Path -LiteralPath $change.Path -PathType Leaf) { $current = [IO.File]::ReadAllText($change.Path) }
        if ($current -cne $change.Before) { throw "Launcher changed during preparation: $($change.Path)" }
        [IO.File]::WriteAllText($change.Path, $change.After, [Text.UTF8Encoding]::new($false))
        $result.ChangedFiles += $change.Path
    }
    if ($userPathBefore -cne $userPathAfter) {
        if ([Environment]::GetEnvironmentVariable('Path', 'User') -cne $userPathBefore) {
            throw 'User PATH changed during file installation; inspect before applying PATH.'
        }
        [Environment]::SetEnvironmentVariable('Path', $userPathAfter, 'User')
    }
} catch {
    throw "Repair did not complete. Inspect partial state and backup '$backupPath'. $($_.Exception.Message)"
}
$result.BackupPath = $backupPath
[pscustomobject]$result
