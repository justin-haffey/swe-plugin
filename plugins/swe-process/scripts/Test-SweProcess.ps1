[CmdletBinding()]
param([string]$PluginRoot, [switch]$SkipBehaviorTests)
$ErrorActionPreference = 'Stop'
if (-not $PluginRoot) { $PluginRoot = Split-Path -Parent $PSScriptRoot }
$PluginRoot = (Resolve-Path -LiteralPath $PluginRoot).Path
$repositoryRoot = Split-Path -Parent (Split-Path -Parent $PluginRoot)
$failures = [Collections.Generic.List[string]]::new()
$count = 0
function Check([bool]$Condition, [string]$Message) {
    $script:count++
    if (-not $Condition) { $failures.Add($Message) }
}
$null = & (Join-Path $PSScriptRoot 'Get-SweCatalog.ps1') -Check
$catalog = Get-Content -Raw -LiteralPath (Join-Path $PluginRoot 'references/SKILL-CATALOG.json') | ConvertFrom-Json
foreach ($package in $catalog.packages) {
    $packageRoot = Join-Path $repositoryRoot "plugins/$($package.name)"
    $manifest = Get-Content -Raw -LiteralPath (Join-Path $packageRoot '.codex-plugin/plugin.json') | ConvertFrom-Json
    Check ($manifest.version -eq '4.0.0' -and $manifest.interface.displayName.EndsWith(' 4.0.0')) "Version/display drift: $($package.name)"
    Check ($manifest.author.name -eq 'Ghostworx.ai, LLC' -and $manifest.interface.developerName -eq 'Ghostworx.ai, LLC') "Publisher drift: $($package.name)"
    foreach ($asset in @($manifest.skills,$manifest.interface.logo,$manifest.interface.composerIcon)) {
        Check ($asset.StartsWith('./') -and (Test-Path -LiteralPath (Join-Path $packageRoot $asset))) "Missing/nonrelative manifest asset: $asset"
    }
    foreach ($skill in $package.skills) {
        $path = Join-Path $repositoryRoot $skill.path
        $text = [IO.File]::ReadAllText($path)
        Check ($text -match ('(?ms)\A---\r?\nname: ' + [regex]::Escape($skill.name) + '\r?\ndescription: [^\r\n]+\r?\n.*?---')) "Skill front matter: $path"
        $skillRoot = Split-Path -Parent $path
        Check (Test-Path -LiteralPath (Join-Path $skillRoot 'agents/openai.yaml')) "Missing skill UI: $path"
    }
}
Check (-not (Test-Path -LiteralPath (Join-Path $repositoryRoot 'scaffolds'))) 'Duplicate root scaffolds returned.'
Check (-not (Test-Path -LiteralPath (Join-Path $PluginRoot 'skills/swe-scaffold/references/solution'))) 'Duplicate packaged scaffold returned.'
Check (-not (Test-Path -LiteralPath (Join-Path $repositoryRoot 'plugins/swe-utility/skills/prototype'))) 'Retired Prototype Mode is shipped.'
foreach ($kind in @('portfolio','solution')) {
    $root = Join-Path $PluginRoot "scaffolds/$kind"
    $guide = [IO.File]::ReadAllText((Join-Path $root 'AGENTS.md'))
    Check ($guide -notmatch 'PROTOTYPE_MODE|\$prototype') "Retired sequencing in $kind guide."
    if ($kind -eq 'solution') { Check ($guide -match 'Delivery mode: Standalone' -and $guide -match '\.swe/features/') 'Fresh solution is not independently complete.' }
    else { Check ($guide -match 'Repository role: Portfolio' -and $guide -match 'integration acceptance') 'Portfolio ownership missing.' }
    $configRoot = Join-Path $root '.codex'
    $config = [IO.File]::ReadAllText((Join-Path $configRoot 'config.toml'))
    foreach ($m in [regex]::Matches($config, '(?m)^config_file\s*=\s*"([^"\r\n]+)"')) {
        $path = $m.Groups[1].Value
        Check (-not [IO.Path]::IsPathRooted($path)) "Absolute native role path: $path"
        $target = Join-Path $configRoot $path
        Check (Test-Path -LiteralPath $target -PathType Leaf) "Missing registered role: $target"
        if (Test-Path -LiteralPath $target) {
            $agent = [IO.File]::ReadAllText($target)
            foreach ($field in @('name','description','model','model_reasoning_effort','developer_instructions')) {
                Check ($agent -match ('(?m)^' + $field + '\s*=')) "Missing role field $field in $target"
            }
        }
    }
}
foreach ($template in Get-ChildItem -LiteralPath (Join-Path $PluginRoot 'skills') -Recurse -File -Filter '*TEMPLATE.md') {
    $text = [IO.File]::ReadAllText($template.FullName)
    $header = [regex]::Match($text, '(?ms)\A---\r?\n(.*?)\r?\n---')
    Check $header.Success "Template header missing: $template"
    foreach ($field in @('artifact_type','id','status','owners','schema_version','links')) { Check ($header.Groups[1].Value -match ('(?m)^' + $field + ':')) "Missing V4 field $field in $template" }
    Check (($header.Groups[1].Value -split '\r?\n').Count -le 10) "Header paperwork grew beyond ten lines: $template"
    Check ($header.Groups[1].Value -notmatch '(?m)^(parent|upstream|traceability):') "Duplicated ancestry in $template"
    Check ($header.Groups[1].Value -match '(?m)^schema_version: 4\r?$') "Template schema drift: $template"
}
# Validate PowerShell syntax without executing authored scripts.
foreach ($scriptFile in Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'plugins') -Recurse -File -Filter '*.ps1') {
    $tokens = $null; $errors = $null
    $null = [Management.Automation.Language.Parser]::ParseFile($scriptFile.FullName, [ref]$tokens, [ref]$errors)
    foreach ($error in $errors) { Check $false "PowerShell parse: $($scriptFile.FullName): $error" }
}
# Resolve literal local Markdown links; examples/placeholders and historical documents
# do not establish shipped runtime dependencies.
foreach ($file in Get-ChildItem -LiteralPath (Join-Path $repositoryRoot 'plugins') -Recurse -File -Filter '*.md') {
    if ($file.Name -eq 'V3-MIGRATION.md') { continue }
    $text = [regex]::Replace([IO.File]::ReadAllText($file.FullName), '(?ms)^```.*?^```\s*$', '')
    foreach ($match in [regex]::Matches($text, '\[[^\]\r\n]+\]\(([^)]+)\)')) {
        $target = $match.Groups[1].Value.Trim('<','>')
        if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:|^#|[\[\]<>]' -or $target -match '\s"') { continue }
        $target = ($target -split '#',2)[0]
        if (-not $target) { continue }
        Check (Test-Path -LiteralPath (Join-Path $file.DirectoryName $target)) "Broken Markdown link: $($file.FullName) -> $target"
    }
}
if ($failures.Count) { foreach ($failure in $failures) { Write-Output "ERROR: $failure" }; exit 1 }
Write-Output "V4 structural contracts passed ($count observations)."
if (-not $SkipBehaviorTests) {
    & (Join-Path $PSScriptRoot 'Test-SweV4Behavior.ps1')
    & (Join-Path $PSScriptRoot 'Test-SweV3Behavior.ps1')
    & (Join-Path $PSScriptRoot 'Test-SweV31Behavior.ps1')
}
