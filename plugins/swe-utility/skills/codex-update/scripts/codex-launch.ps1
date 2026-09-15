# SWE codex-update managed launcher v1
# No parameter binder: every supplied argument belongs to the Codex executable.
$ErrorActionPreference = 'Stop'
try {
    $codexBinRoot = Join-Path (Split-Path -Parent $PSScriptRoot) 'bin'
    $codexCandidates = @(Get-ChildItem -LiteralPath $codexBinRoot -Directory -ErrorAction Stop | ForEach-Object {
        $candidatePath = Join-Path $_.FullName 'codex.exe'
        if (Test-Path -LiteralPath $candidatePath -PathType Leaf) {
            Get-Item -LiteralPath $candidatePath
        }
    } | Sort-Object @{ Expression = 'LastWriteTimeUtc'; Descending = $true }, FullName)
    if ($codexCandidates.Count -eq 0) {
        throw "No desktop Codex CLI exists beneath '$codexBinRoot'. Run codex-update after inspecting the installation."
    }
    # Child directory names are opaque, so select the most recently written binary.
    & $codexCandidates[0].FullName @args
    exit $LASTEXITCODE
} catch {
    [Console]::Error.WriteLine("Codex launcher: " + $_.Exception.Message)
    exit 127
}
