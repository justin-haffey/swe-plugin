@rem SWE codex-update managed launcher v1
@echo off
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0codex-launch.ps1" %*
@exit /b %errorlevel%
