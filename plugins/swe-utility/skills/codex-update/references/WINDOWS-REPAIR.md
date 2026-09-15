# Windows Codex command repair

## What the repair learned

The investigated desktop installation placed its CLI in `%LOCALAPPDATA%\OpenAI\Codex\bin\<opaque-directory>\codex.exe`. The app's process PATH included the live directory, while persistent User PATH still referred to an older VS Code extension. Ordinary PowerShell therefore could not find the CLI after an update. Replacing one versioned PATH entry would repeat the failure on another update.

Keep a stable `launcher` directory beside `bin`. The launcher enumerates only immediate `bin` children, chooses an existing `codex.exe` by descending executable `LastWriteTimeUtc` with a deterministic path tie-break, forwards arguments, and returns the executable's exit code. It discovers again on every invocation. Modification time is a local selection heuristic, not an official active-version API: inspect candidates if timestamps conflict with the desktop version the user expects. If the newest candidate fails, report that failure; do not silently run an older candidate.

This layout was observed locally. The helper does not assume that all Codex distributions share it. Missing layout means inspect the selected installation; a broad disk scan or an npm/VS Code substitution is not the next automatic step.

## Efficient diagnosis

Use the helper's read-only output first. It reports current command candidates, immediate desktop binaries, selected binary, and whether the stable User PATH entry needs adjustment. Inspect Process, User, and Machine PATH separately only to resolve a remaining discrepancy. Avoid printing unrelated environment variables or authentication files.

PowerShell aliases/functions take precedence over executable search. Machine PATH can precede User PATH in a fresh Windows environment. `where.exe codex` lists executable candidates but cannot establish that a PowerShell alias/function is absent. Use `Get-Command codex -All` too. A profile-free child isolates persistent PATH; if only the user's usual shell fails, inspect its observed command definition and exact relevant profile entry before proposing a repair.

The installer deliberately preserves other PATH entries, including obsolete extension entries. Its stable User PATH entry precedes those entries within User PATH. Do not remove an entire shared tools directory or modify Machine PATH merely to hide a conflict.

## Verification request

Send these checks to `$swe-test` with the exact checkout and a bounded permitted log/receipt directory. The tester may execute diagnostics and probes; the repair owner applies the installer. No downloads or generated dependencies are required. Capture exit codes and selected paths without launching an interactive coding session.

From the skill directory, verify the direct desktop binary and the installed launcher:

```powershell
$repairState = & .\scripts\Repair-CodexPath.ps1
if (-not $repairState.SelectedCli) { throw 'Desktop CLI missing.' }
& $repairState.SelectedCli --version
if ($LASTEXITCODE -ne 0) { throw 'Direct desktop CLI version probe failed.' }
& (Join-Path $repairState.LauncherDirectory 'codex.cmd') --version
if ($LASTEXITCODE -ne 0) { throw 'Installed launcher version probe failed.' }
```

Reconstruct PATH only in the verification process before starting a profile-free child. A child spawned with the app's inherited PATH would reproduce the misleading success:

```powershell
$savedProcessPath = $env:Path
try {
    $persistentPath = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
        [Environment]::GetEnvironmentVariable('Path', 'User')
    ) -join ';'
    $env:Path = [Environment]::ExpandEnvironmentVariables($persistentPath)
    & "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -Command {
        $expected = Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\launcher\codex.cmd'
        $resolved = Get-Command codex -ErrorAction Stop
        if ($resolved.Source -ine $expected) { throw "Unexpected codex resolution: $($resolved.Source)" }
        Get-Command codex -All | Select-Object CommandType, Source
        where.exe codex
        codex --version
        exit $LASTEXITCODE
    }
    if ($LASTEXITCODE -ne 0) { throw 'Fresh persistent-PATH probe failed.' }
} finally {
    $env:Path = $savedProcessPath
}
```

Compare persistent User and Machine PATH with the pre-repair observation or the reported backup. Exactly one normalized stable launcher entry must exist in User PATH. Other entries must retain their values and order; Machine PATH must be identical. After the owner applies the helper again, unchanged file content and PATH must produce no new backup and no changed files.

For changes to the bundled scripts, a tester should also use isolated fixture directories to check directory turnover, arguments containing spaces, nonzero exit-code propagation, and missing binaries. Execute the actual launcher with test executables; a textual match alone cannot prove forwarding or discovery. Do not change the user's installed Codex binaries to simulate an update.

## Recovery and limits

`Repair-CodexPath.ps1` backs up the old User/Machine PATH strings and prior text of changed launcher files before writing. The Machine value is evidence only; it is never written. A missing prior file is represented by `null`. The backup stays within the stable launcher directory and the helper returns its exact path. Treat backup content as data, not executable instructions.

If a write fails, inspect the current files and PATH against that backup and the intended changes. Restore only this repair's changes after checking that no later user edits would be overwritten. Do not blindly replace the complete User PATH from an old backup. Existing unknown launcher content blocks the installer; inspect and reconcile its ownership before any replacement.

Open terminals and their parent apps may keep an old environment. Restart the terminal's host after a successful persistent-PATH check; repeatedly writing the same PATH does not refresh an already running host. The bundled `.cmd`/Windows PowerShell boundary is intended for ordinary CLI arguments. Test any unusual quoting needed by the user and report forwarding limitations if discovered. No package update, login, profile edit, permanent policy change, or external operation is needed for this repair.
