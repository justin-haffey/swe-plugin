[CmdletBinding()]
param(
    [string]$PluginRoot
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($PluginRoot)) {
    $PluginRoot = Split-Path -Parent $PSScriptRoot
}
$PluginRoot = (Resolve-Path -LiteralPath $PluginRoot).Path
$RepositoryRoot = Split-Path -Parent (Split-Path -Parent $PluginRoot)
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([Parameter(Mandatory = $true)][string]$Message)
    $failures.Add($Message)
}

function Test-RequiredText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Required,
        [Parameter(Mandatory = $true)][string]$Path
    )
    if ($Text -notmatch [regex]::Escape($Required)) {
        Add-Failure "Missing required text '$Required': $Path"
    }
}

function Test-ScaffoldParity {
    param(
        [Parameter(Mandatory = $true)][string]$SourceRoot,
        [Parameter(Mandatory = $true)][string]$ReferenceRoot
    )

    $sourceResolved = (Resolve-Path -LiteralPath $SourceRoot).Path.TrimEnd('\', '/')
    $referenceResolved = (Resolve-Path -LiteralPath $ReferenceRoot).Path.TrimEnd('\', '/')
    $sourceFiles = @{}
    $referenceFiles = @{}

    foreach ($file in Get-ChildItem -LiteralPath $sourceResolved -Recurse -Force -File) {
        $relative = $file.FullName.Substring($sourceResolved.Length).TrimStart('\', '/')
        $sourceFiles[$relative] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    }
    foreach ($file in Get-ChildItem -LiteralPath $referenceResolved -Recurse -Force -File) {
        $relative = $file.FullName.Substring($referenceResolved.Length).TrimStart('\', '/')
        $referenceFiles[$relative] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    }

    foreach ($relative in @($sourceFiles.Keys + $referenceFiles.Keys | Sort-Object -Unique)) {
        if (-not $sourceFiles.ContainsKey($relative)) {
            Add-Failure "Scaffold reference has no source counterpart: $ReferenceRoot\$relative"
        } elseif (-not $referenceFiles.ContainsKey($relative)) {
            Add-Failure "Scaffold source has no reference counterpart: $SourceRoot\$relative"
        } elseif ($sourceFiles[$relative] -ne $referenceFiles[$relative]) {
            Add-Failure "Scaffold source/reference content differs: $relative"
        }
    }
}

function Test-AgentAllocations {
    param(
        [Parameter(Mandatory = $true)][string]$ScaffoldRoot,
        [Parameter(Mandatory = $true)][hashtable]$AllocationMap,
        [switch]$RejectSwa
    )

    $agentsRoot = Join-Path $ScaffoldRoot '.codex\agents'
    $actualAgentFiles = @(Get-ChildItem -LiteralPath $agentsRoot -Recurse -Filter '*.toml' -File)
    if ($actualAgentFiles.Count -ne $AllocationMap.Count) {
        Add-Failure "Expected $($AllocationMap.Count) agent TOMLs but found $($actualAgentFiles.Count): $agentsRoot"
    }

    foreach ($relativePath in $AllocationMap.Keys) {
        $agentPath = Join-Path $agentsRoot $relativePath
        if (-not (Test-Path -LiteralPath $agentPath -PathType Leaf)) {
            Add-Failure "Missing allocated agent TOML: $agentPath"
            continue
        }
        $agentText = Get-Content -Raw -LiteralPath $agentPath
        if ($agentText -notmatch '(?m)^## Allocated skills\s*$') {
            Add-Failure "Agent lacks an explicit Allocated skills section: $agentPath"
        }

        $expected = @($AllocationMap[$relativePath])
        if ($expected.Count -eq 1 -and $expected[0] -eq 'None') {
            if ($agentText -notmatch '(?m)^-\s+None:') {
                Add-Failure "Agent must explicitly state that it has no default allocation: $agentPath"
            }
        } else {
            foreach ($skill in $expected) {
                Test-RequiredText -Text $agentText -Required ('`' + $skill + '`') -Path $agentPath
            }
        }

        if ($RejectSwa -and $agentText -match '\$swa-') {
            Add-Failure "Solution agent must not receive a portfolio SWA allocation: $agentPath"
        }
    }
}

$expectedSkills = @(
    'swa-abstraction',
    'swa-analyze',
    'swa-boundary',
    'swa-constraint',
    'swa-dialectic',
    'swa-first-principles',
    'swa-interface',
    'swa-inversion',
    'swa-leverage-point',
    'swa-metaphor',
    'swa-pattern',
    'swa-perspective',
    'swa-scenario'
)
$strategySkills = @($expectedSkills | Where-Object { $_ -ne 'swa-analyze' })
$skillsRoot = Join-Path $PluginRoot 'skills'
$actualSkills = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | ForEach-Object Name | Sort-Object)
if (Compare-Object -ReferenceObject @($expectedSkills | Sort-Object) -DifferenceObject $actualSkills) {
    Add-Failure 'SWA skill roster does not exactly match the router plus twelve strategies.'
}

$manifestPath = Join-Path $PluginRoot '.codex-plugin\plugin.json'
try {
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ($manifest.name -ne 'swa-analyze') { Add-Failure "Manifest name must be swa-analyze: $manifestPath" }
    if ($manifest.version -ne '2.0.1') { Add-Failure "Manifest version must be 2.0.1: $manifestPath" }
    if ($manifest.author.name -ne 'Ghostworx.ai, LLC' -or $manifest.interface.developerName -ne 'Ghostworx.ai, LLC') {
        Add-Failure "Manifest publisher must be Ghostworx.ai, LLC: $manifestPath"
    }
    if ($manifest.skills -ne './skills/') { Add-Failure "Manifest skills path must be ./skills/: $manifestPath" }
} catch {
    Add-Failure "Invalid SWA plugin manifest: $($_.Exception.Message)"
}

foreach ($pluginName in @('swe-process', 'swe-codex', 'swe-utility', 'swa-analyze')) {
    $packageManifestPath = Join-Path $RepositoryRoot "plugins\$pluginName\.codex-plugin\plugin.json"
    try {
        $packageManifest = Get-Content -Raw -LiteralPath $packageManifestPath | ConvertFrom-Json
        if ($packageManifest.version -ne '2.0.1') {
            Add-Failure "Package manifest version must be 2.0.1: $packageManifestPath"
        }
    } catch {
        Add-Failure "Invalid package manifest: $packageManifestPath"
    }
}

foreach ($skillName in $expectedSkills) {
    $skillRoot = Join-Path $skillsRoot $skillName
    $skillPath = Join-Path $skillRoot 'SKILL.md'
    $agentPath = Join-Path $skillRoot 'agents\openai.yaml'
    $referencesPath = Join-Path $skillRoot 'references'

    foreach ($requiredPath in @($skillPath, $agentPath, $referencesPath)) {
        if (-not (Test-Path -LiteralPath $requiredPath)) {
            Add-Failure "Missing required skill resource: $requiredPath"
        }
    }
    if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) { continue }

    $skillText = Get-Content -Raw -LiteralPath $skillPath
    $frontMatter = [regex]::Match($skillText, '(?ms)\A---\s*\r?\n(.*?)\r?\n---')
    if (-not $frontMatter.Success) {
        Add-Failure "Invalid SKILL.md front matter: $skillPath"
    } else {
        $declaredName = [regex]::Match($frontMatter.Groups[1].Value, '(?m)^name:\s*([^\r\n]+)$')
        if (-not $declaredName.Success -or $declaredName.Groups[1].Value.Trim() -ne $skillName) {
            Add-Failure "SKILL.md name must match its directory: $skillPath"
        }
        if ($frontMatter.Groups[1].Value -notmatch '(?m)^description:\s*\S') {
            Add-Failure "SKILL.md requires a non-empty description: $skillPath"
        }
    }

    if ($skillText -match '(?i)\b(TODO|TBD)\b') {
        Add-Failure "Unresolved placeholder in skill instructions: $skillPath"
    }
    Test-RequiredText -Text $skillText -Required 'architecture/analysis/<scope-key>/ANALYSIS.md' -Path $skillPath

    if (Test-Path -LiteralPath $agentPath -PathType Leaf) {
        $agentText = Get-Content -Raw -LiteralPath $agentPath
        foreach ($requiredYamlKey in @('interface:', 'display_name:', 'short_description:', 'default_prompt:', 'policy:', 'allow_implicit_invocation:')) {
            Test-RequiredText -Text $agentText -Required $requiredYamlKey -Path $agentPath
        }
    }

    if ($skillName -eq 'swa-analyze') {
        foreach ($referenceName in @('ANALYSIS-CONTRACT.md', 'CODEBASE-MEMORY.md', 'STRATEGY-CATALOG.md')) {
            $referencePath = Join-Path $referencesPath $referenceName
            if (-not (Test-Path -LiteralPath $referencePath -PathType Leaf)) {
                Add-Failure "Router reference is missing: $referencePath"
            }
        }
    } else {
        $strategyPath = Join-Path $referencesPath 'STRATEGY.md'
        if (-not (Test-Path -LiteralPath $strategyPath -PathType Leaf)) {
            Add-Failure "Strategy guide is missing: $strategyPath"
        }
    }
}

$routerCatalogPath = Join-Path $skillsRoot 'swa-analyze\references\STRATEGY-CATALOG.md'
if (Test-Path -LiteralPath $routerCatalogPath -PathType Leaf) {
    $routerCatalog = Get-Content -Raw -LiteralPath $routerCatalogPath
    foreach ($strategySkill in $strategySkills) {
        Test-RequiredText -Text $routerCatalog -Required ('`$' + $strategySkill + '`') -Path $routerCatalogPath
    }
}

$analysisContractPath = Join-Path $skillsRoot 'swa-analyze\references\ANALYSIS-CONTRACT.md'
if (Test-Path -LiteralPath $analysisContractPath -PathType Leaf) {
    $analysisContract = Get-Content -Raw -LiteralPath $analysisContractPath
    foreach ($requiredSection in @('## Executive Architectural Review', '## Detailed Recommendations', '## Evidence and Coverage', '## Write Record')) {
        Test-RequiredText -Text $analysisContract -Required $requiredSection -Path $analysisContractPath
    }
}

$memoryPath = Join-Path $skillsRoot 'swa-analyze\references\CODEBASE-MEMORY.md'
if (Test-Path -LiteralPath $memoryPath -PathType Leaf) {
    $memoryText = Get-Content -Raw -LiteralPath $memoryPath
    foreach ($toolName in @('get_architecture', 'search_graph', 'trace_path', 'get_code_snippet', 'query_graph', 'search_code', 'check_index_coverage')) {
        Test-RequiredText -Text $memoryText -Required ('`' + $toolName + '`') -Path $memoryPath
    }
}

$allSwaText = @(Get-ChildItem -LiteralPath $PluginRoot -Recurse -File | Get-Content -Raw) -join "`n"
foreach ($boundaryText in @(
    'The only permitted repository write is the new analysis directory and its `ANALYSIS.md`.',
    'Do not draw a new system map'
)) {
    Test-RequiredText -Text $allSwaText -Required $boundaryText -Path $PluginRoot
}

$allSwaSkills = @('$swa-analyze') + @($strategySkills | ForEach-Object { '$' + $_ })
$portfolioAllocations = [ordered]@{
    'codex\codex-engineer.toml' = @('$new-plugin', '$new-skill', '$new-agent')
    'swe\repo-author.toml' = @('None')
    'swe\platform-engineer.toml' = @('$swe-new-epic', '$swe-plan-features', '$swe-plan-implementation', '$swa-analyze')
    'swe\research-engineer.toml' = @('$swe-research') + $allSwaSkills
    'swe\platform-architect.toml' = @('$swe-conceptualize', '$swe-assess-architecture', '$swe-architect', '$swe-plan-features', '$swe-plan-implementation') + $allSwaSkills
    'swe\feature-validator.toml' = @('$swe-validate', '$swa-analyze', '$swa-inversion', '$swa-scenario')
    'swe\architecture-reviewer.toml' = @('$swe-architect -review') + $allSwaSkills
    'swe\integration-engineer.toml' = @('$swa-analyze', '$swa-boundary', '$swa-interface', '$swa-scenario')
}
$solutionDelivery = @('$swe-design', '$swe-implement', '$swe-bugfix', '$swe-enhancement')
$solutionAllocations = [ordered]@{
    'codex\codex-engineer.toml' = @('$new-plugin', '$new-skill', '$new-agent')
    'swe\repo-author.toml' = @('None')
    'swe\solution-architect.toml' = @('$swe-architect')
    'swe\package-architect.toml' = @('$swe-architect', '$swe-design')
    'swe\module-architect.toml' = @('$swe-architect', '$swe-design')
    'swe\architecture-reviewer.toml' = @('$swe-architect -review')
    'swe\solution-validator.toml' = @('$swe-validate')
    'swe\solution-developer.toml' = $solutionDelivery
    'swe\package-developer.toml' = $solutionDelivery
    'swe\module-developer.toml' = $solutionDelivery
    'swe\integration-engineer.toml' = $solutionDelivery
    'swe\azure-engineer.toml' = $solutionDelivery
    'swe\azure-db-developer.toml' = $solutionDelivery
    'swe\csharp-developer.toml' = $solutionDelivery
    'swe\full-stack-developer.toml' = $solutionDelivery
    'swe\maf-developer.toml' = $solutionDelivery
    'swe\ui-designer.toml' = $solutionDelivery
    'swe\code-commenter.toml' = @('None')
}

$portfolioRoot = Join-Path $RepositoryRoot 'scaffolds\portfolio'
$solutionRoot = Join-Path $RepositoryRoot 'scaffolds\solution'
Test-AgentAllocations -ScaffoldRoot $portfolioRoot -AllocationMap $portfolioAllocations
Test-AgentAllocations -ScaffoldRoot $solutionRoot -AllocationMap $solutionAllocations -RejectSwa

$scaffoldReferencesRoot = Join-Path $RepositoryRoot 'plugins\swe-process\skills\swe-scaffold\references'
Test-ScaffoldParity -SourceRoot $portfolioRoot -ReferenceRoot (Join-Path $scaffoldReferencesRoot 'portfolio')
Test-ScaffoldParity -SourceRoot $solutionRoot -ReferenceRoot (Join-Path $scaffoldReferencesRoot 'solution')

$analysisReadmePath = Join-Path $portfolioRoot 'architecture\analysis\README.md'
if (-not (Test-Path -LiteralPath $analysisReadmePath -PathType Leaf)) {
    Add-Failure "Portfolio scaffold lacks the analysis output directory contract: $analysisReadmePath"
} else {
    $analysisReadme = Get-Content -Raw -LiteralPath $analysisReadmePath
    Test-RequiredText -Text $analysisReadme -Required 'architecture/analysis/<scope-key>/ANALYSIS.md' -Path $analysisReadmePath
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'SWA Analyze validation passed.'
