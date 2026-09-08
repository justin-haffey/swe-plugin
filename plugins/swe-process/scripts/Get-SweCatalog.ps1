[CmdletBinding()]
param(
    [string]$RepositoryRoot,
    [switch]$Write,
    [switch]$Check
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
}
if ($Write -and $Check) { throw 'Choose Write or Check, not both.' }
$RepositoryRoot = (Resolve-Path -LiteralPath $RepositoryRoot).Path
$packagesRoot = Join-Path $RepositoryRoot 'plugins'
$catalogPath = Join-Path $packagesRoot 'swe-process/references/SKILL-CATALOG.json'
$packages = @(Get-ChildItem -LiteralPath $packagesRoot -Directory | Sort-Object Name | ForEach-Object {
    $package = $_
    $manifest = Get-Content -Raw -LiteralPath (Join-Path $package.FullName '.codex-plugin/plugin.json') | ConvertFrom-Json
    if ($manifest.name -ne $package.Name) { throw "Manifest/directory identity mismatch: $($package.Name)" }
    $skills = @(Get-ChildItem -LiteralPath (Join-Path $package.FullName 'skills') -Directory | Where-Object {
        # Empty local directories are not shipped skills. Nonempty incomplete bundles fail closed.
        $files = @(Get-ChildItem -LiteralPath $_.FullName -Recurse -Force -File)
        $files.Count -gt 0
    } | Sort-Object Name | ForEach-Object {
        $skill = $_
        $text = Get-Content -Raw -LiteralPath (Join-Path $skill.FullName 'SKILL.md')
        if ($text -notmatch ('(?m)^name:\s*["'']?' + [regex]::Escape($skill.Name) + '["'']?\s*$')) {
            throw "Skill/directory identity mismatch: $($skill.FullName)"
        }
        [ordered]@{
            name = $skill.Name
            path = "plugins/$($package.Name)/skills/$($skill.Name)/SKILL.md"
            visibility = $(if ($skill.Name -eq 'swe-bridge') { 'internal' } else { 'public' })
        }
    })
    [ordered]@{ name = $manifest.name; version = $manifest.version; skills = $skills }
})
if (($packages.name -join ',') -ne 'swa-analyze,swe-codex,swe-process,swe-utility') {
    throw 'The release must contain the four supported SWE packages.'
}
$catalog = [ordered]@{ schema_version = 3; release_version = '3.1.0'; packages = $packages }
$json = ($catalog | ConvertTo-Json -Depth 10) + "`n"
if ($Write) {
    [IO.File]::WriteAllText($catalogPath, $json, [Text.UTF8Encoding]::new($false))
    Write-Output $catalogPath
} elseif ($Check) {
    if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) { throw "Missing generated catalog: $catalogPath" }
    $existing = Get-Content -Raw -LiteralPath $catalogPath | ConvertFrom-Json
    if (($existing | ConvertTo-Json -Depth 10 -Compress) -cne ($catalog | ConvertTo-Json -Depth 10 -Compress)) {
        throw 'Skill catalog is stale. Run Get-SweCatalog.ps1 -Write after reviewing the package inventory.'
    }
    if (@($packages | Where-Object version -ne $catalog.release_version).Count) { throw 'Package versions differ from the chosen release version.' }
    Write-Output 'Skill catalog matches all four package inventories and release versions.'
} else { [pscustomobject]$catalog }
