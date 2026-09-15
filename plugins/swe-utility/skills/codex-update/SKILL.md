---
name: codex-update
description: Repair the Windows PowerShell codex command after a Codex desktop update changes its CLI location. Use when codex disappears, resolves to an obsolete executable, or fails after an upgrade. Do not use to install or upgrade Codex itself, change account settings, or troubleshoot unrelated CLI errors.
---
# Codex Update

Restore `codex` with a stable per-user launcher that discovers the desktop app's current CLI each time it runs. Keep versioned installation directories out of new persistent PATH entries.

## Diagnose once

Read [the Windows repair notes](references/WINDOWS-REPAIR.md) before repair. On Windows, run the bundled helper without `-Apply` from this skill's directory:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Repair-CodexPath.ps1
```

The helper inspects the current user's desktop installation, command resolution, and persistent PATH; it makes no changes. Compare its findings with the user's failing shell. A working command in the Codex app's own terminal does not establish that an ordinary PowerShell terminal can find it.

- If the desktop CLI exists and PATH or an older bundled CLI explains the failure, continue below.
- If an alias, function, profile, or Machine PATH entry wins resolution, inspect that exact conflict before changing it. The installer cannot fix a higher-precedence command.
- If the desktop layout is missing or unexpected, stop the automatic repair. Inspect the user's selected installation and current official Codex guidance. Do not substitute a VS Code extension or install another distribution silently.
- If fresh resolution and `codex --version` already work, report that evidence and make no change. Authentication, network, and session failures require separate diagnosis.

## Apply the bounded repair

A request to fix this command authorizes the local launcher and User PATH repair. An inspection-only request does not. Run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Repair-CodexPath.ps1 -Apply
```

The helper installs `codex.cmd` and `codex-launch.ps1` under `%LOCALAPPDATA%\OpenAI\Codex\launcher`, puts that stable directory first in User PATH, and records the previous state before changes. Existing unrecognized launcher files block replacement. Repeated application produces no new changes when the installed content and PATH already match.

Do not add a hash/version directory to PATH, edit Machine PATH, rewrite a PowerShell profile, change execution policy persistently, modify Codex packages, or remove older installations as part of this repair. Keep unrelated PATH entries. Resolve a reported file collision with its owner; do not add a force-overwrite option.

## Verify and stop

Route command execution for verification through `$swe-test` to `test-runner` on `gpt-5.6-luna` at `medium`. Supply the exact working directory, permitted result directory, commands from the repair notes, and these criteria:

1. The absolute desktop executable and installed launcher both return a Codex version with exit code zero.
2. A child PowerShell with PATH reconstructed from persistent Machine and User values resolves `codex` to the stable launcher and runs `codex --version` successfully.
3. The intended User PATH entry persists, Machine PATH is unchanged, and unrelated User PATH entries are preserved.

Missing tester capability or a failed observation is incomplete verification, not success. Return code or script defects to the repair owner. Bound repair/review to two cycles total; do not retry an identical failed write. Stop on an unexpected layout, ownership conflict, or unresolved command precedence. Existing terminals may need their hosting application restarted to inherit PATH.

Report the cause, selected CLI path/version, stable launcher path, actual modifications, backup location if created, and verification outcome. Distinguish observed success now from future compatibility: discovery tolerates changed child-directory names, but an upstream installation-layout change requires fresh inspection.
