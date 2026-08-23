[CmdletBinding()]
param(
    [string]$PluginRoot,
    [switch]$SkipBehaviorTests
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($PluginRoot)) {
    $PluginRoot = Split-Path -Parent $PSScriptRoot
}
$PluginRoot = (Resolve-Path -LiteralPath $PluginRoot).Path
$failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([Parameter(Mandatory = $true)][string]$Message)
    $failures.Add($Message)
}

function Get-RelativeFileRecords {
    param([Parameter(Mandatory = $true)][string]$Root)

    $resolvedRoot = (Resolve-Path -LiteralPath $Root).Path.TrimEnd('\', '/')
    @(Get-ChildItem -LiteralPath $resolvedRoot -Recurse -Force -File | ForEach-Object {
        [pscustomobject]@{
            Relative = $_.FullName.Substring($resolvedRoot.Length).TrimStart('\', '/')
            Hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
        }
    })
}

function Test-AgentRegistry {
    param(
        [Parameter(Mandatory = $true)][string]$ScaffoldRoot,
        [Parameter(Mandatory = $true)][string[]]$ExpectedRoster
    )

    $configPath = Join-Path $ScaffoldRoot '.codex\config.toml'
    if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
        Add-Failure "Missing scaffold Codex registry: $configPath"
        return
    }
    $configText = Get-Content -Raw -LiteralPath $configPath
    if ($configText -match '(?i)[A-Z]:\\Users\\|/Users/[^/]+/') {
        Add-Failure "Scaffold registry contains a machine-specific path: $configPath"
    }
    $actualRoster = @([regex]::Matches($configText, '(?m)^\[agents\.([a-z0-9_]+)\]\s*$') | ForEach-Object { $_.Groups[1].Value } | Sort-Object)
    $expectedSorted = @($ExpectedRoster | Sort-Object)
    if (Compare-Object -ReferenceObject $expectedSorted -DifferenceObject $actualRoster) {
        Add-Failure "Agent roster mismatch: $configPath"
    }

    foreach ($match in [regex]::Matches($configText, '(?m)^config_file\s*=\s*"([^"]+)"\s*$')) {
        $relative = $match.Groups[1].Value -replace '/', '\'
        if ([System.IO.Path]::IsPathRooted($relative)) {
            Add-Failure "Agent config_file must be relative: $configPath -> $relative"
            continue
        }
        $agentPath = Join-Path (Join-Path $ScaffoldRoot '.codex') $relative
        if (-not (Test-Path -LiteralPath $agentPath -PathType Leaf)) {
            Add-Failure "Registered agent file is missing: $agentPath"
            continue
        }
        $agentText = Get-Content -Raw -LiteralPath $agentPath
        foreach ($field in @('name', 'description', 'developer_instructions')) {
            if ($agentText -notmatch "(?m)^$([regex]::Escape($field))\s*=") {
                Add-Failure "Agent TOML missing '$field': $agentPath"
            }
        }
    }
}

function Test-ContextLayout {
    param(
        [Parameter(Mandatory = $true)][string]$ScaffoldRoot,
        [Parameter(Mandatory = $true)][ValidateSet('portfolio', 'solution')][string]$ScaffoldName
    )

    if ($ScaffoldName -eq 'portfolio') {
        $mapPath = Join-Path $ScaffoldRoot 'CONTEXT-MAP.md'
        if (-not (Test-Path -LiteralPath $mapPath -PathType Leaf)) {
            Add-Failure "Portfolio scaffold lacks root context map: $mapPath"
            return
        }
        $mapText = Get-Content -Raw -LiteralPath $mapPath
        foreach ($contextName in @('WORK-CONTEXT.md', 'STRUCTURAL-CONTEXT.md', 'ENGINEERING-CONTEXT.md')) {
            $contextPath = Join-Path $ScaffoldRoot ('.swe\context\' + $contextName)
            if (-not (Test-Path -LiteralPath $contextPath -PathType Leaf)) {
                Add-Failure "Portfolio context vocabulary is missing: $contextPath"
            }
            $legacyPath = Join-Path $ScaffoldRoot $contextName
            if (Test-Path -LiteralPath $legacyPath) {
                Add-Failure "Portfolio context vocabulary must not remain at the root: $legacyPath"
            }
            $expectedLink = './.swe/context/' + $contextName
            if ($mapText -notmatch [regex]::Escape($expectedLink)) {
                Add-Failure "Portfolio context map does not link '$expectedLink': $mapPath"
            }
        }
        return
    }

    $singleContextPath = Join-Path $ScaffoldRoot 'CONTEXT.md'
    $mapPath = Join-Path $ScaffoldRoot 'CONTEXT-MAP.md'
    if (-not (Test-Path -LiteralPath $singleContextPath -PathType Leaf)) {
        Add-Failure "Initial solution scaffold lacks root single-context vocabulary: $singleContextPath"
    }
    if (Test-Path -LiteralPath $mapPath) {
        Add-Failure "Initial solution scaffold must not contain both root context forms: $mapPath"
    }
}

$expectedSkills = @(
    'swe-new-epic', 'swe-research', 'swe-conceptualize', 'swe-assess-architecture',
    'swe-architect', 'swe-plan-features', 'swe-plan-implementation', 'swe-design',
    'swe-implement', 'swe-validate', 'swe-bugfix', 'swe-enhancement', 'swe-scaffold'
)
$templateContract = [ordered]@{
    'skills\swe-new-epic\references\EPIC-TEMPLATE.md' = @('epic', 'Draft')
    'skills\swe-research\references\RESEARCH-TEMPLATE.md' = @('research', 'Complete')
    'skills\swe-conceptualize\references\CONCEPT-TEMPLATE.md' = @('concept', 'Draft')
    'skills\swe-assess-architecture\references\ARCHITECTURE-IMPACT-TEMPLATE.md' = @('architecture_impact', 'Draft')
    'skills\swe-architect\references\PLATFORM-ARCHITECTURE-TEMPLATE.md' = @('platform_architecture', 'Target')
    'skills\swe-architect\references\SOLUTION-ARCHITECTURE-TEMPLATE.md' = @('solution_architecture', 'Target')
    'skills\swe-architect\references\PACKAGE-ARCHITECTURE-TEMPLATE.md' = @('package_architecture', 'Target')
    'skills\swe-architect\references\MODULE-ARCHITECTURE-TEMPLATE.md' = @('module_architecture', 'Target')
    'skills\swe-architect\references\SYSTEM-VIEW-TEMPLATE.md' = @('system_view', 'Target')
    'skills\swe-architect\references\ADR-TEMPLATE.md' = @('architecture_decision', 'Proposed')
    'skills\swe-architect\references\CONTRACT-TEMPLATE.md' = @('architecture_contract', 'Proposed')
    'skills\swe-plan-features\references\FEATURE-TEMPLATE.md' = @('feature', 'Draft')
    'skills\swe-plan-implementation\references\IMPLEMENTATION-PLAN-TEMPLATE.md' = @('implementation_plan', 'Draft')
    'skills\swe-design\references\DESIGN-TEMPLATE.md' = @('design', 'Draft')
    'skills\swe-implement\references\EVIDENCE-TEMPLATE.md' = @('implementation_evidence', 'Complete')
    'skills\swe-validate\references\VALIDATION-TEMPLATE.md' = @('validation', 'Draft')
    'skills\swe-bugfix\references\BUGFIX-TEMPLATE.md' = @('bugfix', 'Active')
    'skills\swe-enhancement\references\ENHANCEMENT-TEMPLATE.md' = @('enhancement', 'Active')
}
$decisionTemplates = @(
    'EPIC-TEMPLATE.md', 'CONCEPT-TEMPLATE.md', 'ARCHITECTURE-IMPACT-TEMPLATE.md',
    'PLATFORM-ARCHITECTURE-TEMPLATE.md', 'SOLUTION-ARCHITECTURE-TEMPLATE.md',
    'PACKAGE-ARCHITECTURE-TEMPLATE.md', 'MODULE-ARCHITECTURE-TEMPLATE.md', 'SYSTEM-VIEW-TEMPLATE.md',
    'ADR-TEMPLATE.md', 'CONTRACT-TEMPLATE.md', 'FEATURE-TEMPLATE.md',
    'IMPLEMENTATION-PLAN-TEMPLATE.md', 'DESIGN-TEMPLATE.md', 'VALIDATION-TEMPLATE.md'
)
$traceabilityContract = [ordered]@{
    'FEATURE-TEMPLATE.md' = @('epic')
    'IMPLEMENTATION-PLAN-TEMPLATE.md' = @('epic', 'feature')
    'DESIGN-TEMPLATE.md' = @('epic', 'feature', 'implementation_plan')
    'EVIDENCE-TEMPLATE.md' = @('epic', 'feature', 'implementation_plan', 'design')
    'VALIDATION-TEMPLATE.md' = @('epic', 'feature', 'implementation_plan', 'design', 'evidence')
}
$diagramContract = [ordered]@{
    'PLATFORM-ARCHITECTURE-TEMPLATE.md' = @('flowchart')
    'SOLUTION-ARCHITECTURE-TEMPLATE.md' = @('flowchart', 'sequenceDiagram')
    'PACKAGE-ARCHITECTURE-TEMPLATE.md' = @('flowchart')
    'MODULE-ARCHITECTURE-TEMPLATE.md' = @('flowchart')
    'SYSTEM-VIEW-TEMPLATE.md' = @('flowchart', 'sequenceDiagram')
}

$manifestPath = Join-Path $PluginRoot '.codex-plugin\plugin.json'
try {
    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    if ($manifest.name -ne 'swe-process') { Add-Failure "Manifest name must be swe-process: $manifestPath" }
    if ($manifest.version -ne '2.0.1') { Add-Failure "Manifest version must be 2.0.1: $manifestPath" }
    if ($manifest.author.name -ne 'Ghostworx.ai, LLC' -or $manifest.interface.developerName -ne 'Ghostworx.ai, LLC') {
        Add-Failure "Manifest publisher must be Ghostworx.ai, LLC: $manifestPath"
    }
} catch {
    Add-Failure "Invalid plugin manifest: $($_.Exception.Message)"
}

$skillsRoot = Join-Path $PluginRoot 'skills'
$actualSkills = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | ForEach-Object Name | Sort-Object)
if (Compare-Object -ReferenceObject @($expectedSkills | Sort-Object) -DifferenceObject $actualSkills) {
    Add-Failure 'Skill roster does not exactly match the 13-skill v2 roster.'
}

foreach ($skillName in $expectedSkills) {
    $skillRoot = Join-Path $skillsRoot $skillName
    $skillPath = Join-Path $skillRoot 'SKILL.md'
    $uiPath = Join-Path $skillRoot 'agents\openai.yaml'
    $referencesPath = Join-Path $skillRoot 'references'
    foreach ($requiredPath in @($skillPath, $uiPath, $referencesPath)) {
        if (-not (Test-Path -LiteralPath $requiredPath)) { Add-Failure "Missing required skill resource: $requiredPath" }
    }
    if (Test-Path -LiteralPath $skillPath -PathType Leaf) {
        $skillText = Get-Content -Raw -LiteralPath $skillPath
        if ($skillText -notmatch "(?ms)^---\s*.*?^name:\s*$([regex]::Escape($skillName))\s*$.*?^description:\s*\S+.*?^---\s*$") {
            Add-Failure "Invalid SKILL.md frontmatter: $skillPath"
        }
    }
    if (Test-Path -LiteralPath $uiPath -PathType Leaf) {
        $uiText = Get-Content -Raw -LiteralPath $uiPath
        if ($uiText -notmatch [regex]::Escape("`$$skillName")) { Add-Failure "default_prompt must mention `${skillName}: $uiPath" }
        $shortMatch = [regex]::Match($uiText, '(?m)^\s*short_description:\s*"([^"]+)"\s*$')
        if (-not $shortMatch.Success -or $shortMatch.Groups[1].Value.Length -lt 25 -or $shortMatch.Groups[1].Value.Length -gt 64) {
            Add-Failure "short_description must be 25-64 characters: $uiPath"
        }
    }
}

$scaffoldReferences = Join-Path $skillsRoot 'swe-scaffold\references'
$actualTemplates = @(Get-ChildItem -LiteralPath $skillsRoot -Recurse -File -Filter '*TEMPLATE.md' |
    Where-Object { -not $_.FullName.StartsWith($scaffoldReferences, [System.StringComparison]::OrdinalIgnoreCase) } |
    ForEach-Object { $_.FullName.Substring($PluginRoot.Length).TrimStart('\', '/') -replace '/', '\' } | Sort-Object)
$expectedTemplates = @($templateContract.Keys | Sort-Object)
if (Compare-Object -ReferenceObject $expectedTemplates -DifferenceObject $actualTemplates) {
    Add-Failure 'Canonical process template set must contain exactly the 18 v2 templates.'
}

$commonFields = @('title', 'artifact_type', 'id', 'status', 'authority', 'scope', 'parent', 'upstream', 'owners', 'created', 'updated', 'template_version')
foreach ($relativeTemplate in $templateContract.Keys) {
    $templatePath = Join-Path $PluginRoot $relativeTemplate
    if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) { continue }
    $templateText = Get-Content -Raw -LiteralPath $templatePath
    $frontmatterMatch = [regex]::Match($templateText, '(?ms)^---\s*\r?\n(?<header>.*?)\r?\n---\s*\r?\n')
    if (-not $frontmatterMatch.Success) {
        Add-Failure "Template lacks bounded YAML frontmatter: $templatePath"
        continue
    }
    $header = $frontmatterMatch.Groups['header'].Value
    foreach ($field in $commonFields) {
        if ($header -notmatch "(?m)^$([regex]::Escape($field)):\s*") { Add-Failure "Template missing '$field': $templatePath" }
    }
    $expectedArtifactType = $templateContract[$relativeTemplate][0]
    $expectedStatus = $templateContract[$relativeTemplate][1]
    $artifactTypePattern = '(?m)^artifact_type:\s*"{0}"\s*$' -f [regex]::Escape($expectedArtifactType)
    if ($header -notmatch $artifactTypePattern) {
        Add-Failure "Template artifact_type must be '$expectedArtifactType': $templatePath"
    }
    $statusPattern = '(?m)^status:\s*"{0}"\s*$' -f [regex]::Escape($expectedStatus)
    if ($header -notmatch $statusPattern) {
        Add-Failure "Template initial status must be '$expectedStatus': $templatePath"
    }
    if ($header -notmatch '(?ms)^upstream:\s*\r?\n\s{2}repository:\s*.+\r?\n\s{2}artifact_id:\s*.+\r?\n\s{2}path:\s*.+\r?\n\s{2}revision:\s*.+') {
        Add-Failure "Template upstream locator is incomplete: $templatePath"
    }
    if ($templateText -match '\{\{' -or $templateText -match '\[NNN-SHORT_NAME\]') {
        Add-Failure "Template uses a forbidden placeholder form: $templatePath"
    }
    foreach ($placeholder in [regex]::Matches($templateText, '\[([A-Za-z0-9_-]+)\]')) {
        if ($placeholder.Groups[1].Value -cnotmatch '^[A-Z0-9_]+$') {
            Add-Failure "Template placeholder must be UPPER_SNAKE_CASE: $templatePath -> $($placeholder.Value)"
        }
    }
    if ($decisionTemplates -contains (Split-Path -Leaf $templatePath)) {
        foreach ($approvalField in @('Mode', 'Author', 'Approver', 'Decision', 'Recorded', 'Evidence', 'Bypass reason')) {
            if ($templateText -notmatch "(?m)^\|\s*$([regex]::Escape($approvalField))\s*\|") {
                Add-Failure "Decision template approval record missing '$approvalField': $templatePath"
            }
        }
    }
    $leaf = Split-Path -Leaf $templatePath
    if ($diagramContract.Contains($leaf)) {
        $mermaidBlocks = @([regex]::Matches($templateText, '(?ms)```mermaid\s*\r?\n(?<body>.*?)\r?\n```'))
        if ($mermaidBlocks.Count -lt $diagramContract[$leaf].Count) {
            Add-Failure "Architecture template lacks its core Mermaid views: $templatePath"
        }
        foreach ($mermaidBlock in $mermaidBlocks) {
            if ($mermaidBlock.Groups['body'].Value -notmatch '\[[A-Z0-9_]+\]') {
                Add-Failure "Architecture Mermaid view lacks a replaceable sample placeholder: $templatePath"
            }
        }
        foreach ($diagramType in $diagramContract[$leaf]) {
            if (-not ($mermaidBlocks | Where-Object { $_.Groups['body'].Value -match "(?m)^$([regex]::Escape($diagramType))(?:\s|$)" })) {
                Add-Failure "Architecture template lacks a '$diagramType' Mermaid view: $templatePath"
            }
        }
    }
    if ($traceabilityContract.Contains($leaf)) {
        if ($header -notmatch '(?m)^traceability:\s*$') { Add-Failure "Template lacks traceability map: $templatePath" }
        foreach ($locatorName in $traceabilityContract[$leaf]) {
            $locatorPattern = "(?ms)^\s{2}$([regex]::Escape($locatorName)):\s*\r?\n\s{4}repository:\s*.+\r?\n\s{4}artifact_id:\s*.+\r?\n\s{4}path:\s*.+\r?\n\s{4}revision:\s*.+"
            if ($header -notmatch $locatorPattern) { Add-Failure "Traceability locator '$locatorName' is incomplete: $templatePath" }
        }
        if ($templateText -notmatch 'AC-001') { Add-Failure "Traceability template lacks stable acceptance criterion IDs: $templatePath" }
    }
}

$contractPath = Join-Path $PluginRoot 'references\ARTIFACT-CONTRACT.md'
if (-not (Test-Path -LiteralPath $contractPath -PathType Leaf)) {
    Add-Failure "Missing artifact contract: $contractPath"
} else {
    $contractText = Get-Content -Raw -LiteralPath $contractPath
    foreach ($requiredText in @('Draft -> InReview -> Accepted -> Superseded', 'Target -> Implemented -> Current -> Superseded', 'Proposed -> Accepted -> Superseded', 'auto-approve', 'force')) {
        if ($contractText -notmatch [regex]::Escape($requiredText)) { Add-Failure "Artifact contract missing semantic rule '$requiredText'." }
    }
    foreach ($requiredText in @('EO-001', 'Active -> Implemented -> Validated -> Closed', 'Decision: Waived', 'named independent validator')) {
        if ($contractText -notmatch [regex]::Escape($requiredText)) { Add-Failure "Artifact contract missing fast-path or identifier rule '$requiredText'." }
    }
}

$epicTemplatePath = Join-Path $skillsRoot 'swe-new-epic\references\EPIC-TEMPLATE.md'
if (Test-Path -LiteralPath $epicTemplatePath -PathType Leaf) {
    $epicTemplateText = Get-Content -Raw -LiteralPath $epicTemplatePath
    if ($epicTemplateText -notmatch 'EO-001') { Add-Failure "Epic template must use stable Epic-local EO-001 outcomes: $epicTemplatePath" }
    if ($epicTemplateText -match 'AC-001') { Add-Failure "Epic template must reserve AC-001 for Feature-local criteria: $epicTemplatePath" }
}

$lifecycleSkills = [ordered]@{
    'swe-architect\SKILL.md' = @('Target', 'Implemented', 'Current')
    'swe-validate\SKILL.md' = @('Accepted', 'Rejected', 'Blocked', 'Target', 'Implemented', 'Current')
}
foreach ($relativeSkill in $lifecycleSkills.Keys) {
    $skillPath = Join-Path $skillsRoot $relativeSkill
    if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) { continue }
    $skillText = Get-Content -Raw -LiteralPath $skillPath
    foreach ($requiredToken in $lifecycleSkills[$relativeSkill]) {
        if ($skillText -notmatch [regex]::Escape('`' + $requiredToken + '`')) {
            Add-Failure "Lifecycle skill lacks canonical token '$requiredToken': $skillPath"
        }
        $illegalToken = '`' + $requiredToken.ToLowerInvariant() + '`'
        if ($skillText -cmatch [regex]::Escape($illegalToken)) {
            Add-Failure "Lifecycle skill contains illegal lowercase token '$illegalToken': $skillPath"
        }
    }
}

$fastPathTemplates = @(
    (Join-Path $skillsRoot 'swe-bugfix\references\BUGFIX-TEMPLATE.md'),
    (Join-Path $skillsRoot 'swe-enhancement\references\ENHANCEMENT-TEMPLATE.md')
)
foreach ($fastPathTemplate in $fastPathTemplates) {
    if (-not (Test-Path -LiteralPath $fastPathTemplate -PathType Leaf)) { continue }
    $fastPathText = Get-Content -Raw -LiteralPath $fastPathTemplate
    foreach ($requiredField in @('Validation and Closure', 'Independent validation required', 'Implemented recorded', 'Validator', 'Independence', 'Decision', 'Validation recorded', 'Evidence', 'Closure owner', 'Closure recorded', 'Waiver rationale')) {
        if ($fastPathText -notmatch [regex]::Escape($requiredField)) { Add-Failure "Fast-path template lacks '$requiredField': $fastPathTemplate" }
    }
}

$phaseGateContract = [ordered]@{
    'swe-conceptualize\SKILL.md' = @('EPIC.md', 'Accepted')
    'swe-assess-architecture\SKILL.md' = @('Epic and Concept', 'Accepted')
    'swe-architect\SKILL.md' = @('Accepted` Concept', 'Accepted` architecture-impact assessment')
    'swe-plan-features\SKILL.md' = @('Accepted` `EPIC.md`', 'Accepted` `CONCEPT.md`', 'Accepted` Approval Record')
    'swe-plan-implementation\SKILL.md' = @('Accepted` `FEATURE.md`', 'Accepted` Approval Record')
    'swe-design\SKILL.md' = @('Feature and Implementation Plan to be `Accepted`', 'Accepted` Approval Record')
    'swe-validate\SKILL.md' = @('Accepted` for Feature, Implementation Plan, Design', 'Complete` for Evidence', 'Blocked` validation')
}
foreach ($relativeSkill in $phaseGateContract.Keys) {
    $skillPath = Join-Path $skillsRoot $relativeSkill
    if (-not (Test-Path -LiteralPath $skillPath -PathType Leaf)) { continue }
    $skillText = Get-Content -Raw -LiteralPath $skillPath
    foreach ($requiredPhrase in $phaseGateContract[$relativeSkill]) {
        if ($skillText -notmatch [regex]::Escape($requiredPhrase)) { Add-Failure "Phase gate '$requiredPhrase' is missing: $skillPath" }
    }
}

$nonScaffoldFiles = @(Get-ChildItem -LiteralPath $PluginRoot -Recurse -File | Where-Object {
    -not $_.FullName.StartsWith($scaffoldReferences, [System.StringComparison]::OrdinalIgnoreCase)
})
$processText = ($nonScaffoldFiles | Where-Object { $_.Extension -in '.md', '.yaml' } | ForEach-Object { Get-Content -Raw -LiteralPath $_.FullName }) -join "`n"
if ($processText -match '(?i)[A-Z]:\\Users\\|/Users/[^/]+/') { Add-Failure 'Process resources contain a machine-specific absolute user path.' }
if ($processText -cmatch 'research/') { Add-Failure 'Process resources must use the canonical RESEARCH/ directory casing.' }
foreach ($canonicalName in @('PLATFORM-ARCHITECTURE.md', 'SOLUTION-ARCHITECTURE.md', 'PACKAGE-ARCHITECTURE.md', 'MODULE-ARCHITECTURE.md')) {
    if ($processText -notmatch [regex]::Escape($canonicalName)) { Add-Failure "Canonical architecture filename is not represented: $canonicalName" }
}

$portfolioRoster = @('codex_engineer', 'repo_author', 'platform_engineer', 'research_engineer', 'platform_architect', 'feature_validator', 'architecture_reviewer', 'integration_engineer')
$solutionRoster = @('codex_engineer', 'repo_author', 'solution_architect', 'package_architect', 'module_architect', 'solution_developer', 'package_developer', 'module_developer', 'integration_engineer', 'architecture_reviewer', 'solution_validator', 'azure_engineer', 'azure_db_developer', 'csharp_developer', 'full_stack_developer', 'maf_developer', 'ui_designer', 'code_commenter')
foreach ($scaffoldName in @('portfolio', 'solution')) {
    $referenceRoot = Join-Path $scaffoldReferences $scaffoldName
    $roster = if ($scaffoldName -eq 'portfolio') { $portfolioRoster } else { $solutionRoster }
    Test-AgentRegistry -ScaffoldRoot $referenceRoot -ExpectedRoster $roster
    Test-ContextLayout -ScaffoldRoot $referenceRoot -ScaffoldName $scaffoldName
}

$workspaceRoot = Split-Path -Parent (Split-Path -Parent $PluginRoot)
$sourceScaffoldsRoot = Join-Path $workspaceRoot 'scaffolds'
if (Test-Path -LiteralPath $sourceScaffoldsRoot -PathType Container) {
    foreach ($scaffoldName in @('portfolio', 'solution')) {
        $sourceRoot = Join-Path $sourceScaffoldsRoot $scaffoldName
        $referenceRoot = Join-Path $scaffoldReferences $scaffoldName
        if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
            Add-Failure "Source scaffold is missing: $sourceRoot"
            continue
        }
        $roster = if ($scaffoldName -eq 'portfolio') { $portfolioRoster } else { $solutionRoster }
        Test-AgentRegistry -ScaffoldRoot $sourceRoot -ExpectedRoster $roster
        Test-ContextLayout -ScaffoldRoot $sourceRoot -ScaffoldName $scaffoldName
        $sourceRecords = @(Get-RelativeFileRecords -Root $sourceRoot | Sort-Object Relative)
        $referenceRecords = @(Get-RelativeFileRecords -Root $referenceRoot | Sort-Object Relative)
        if (Compare-Object -ReferenceObject $sourceRecords -DifferenceObject $referenceRecords -Property Relative, Hash) {
            Add-Failure "Source/reference scaffold parity failed: $scaffoldName"
        }
    }

    $configPaths = @(
        (Join-Path $workspaceRoot '.codex\config.toml'),
        (Join-Path $sourceScaffoldsRoot 'portfolio\.codex\config.toml'),
        (Join-Path $sourceScaffoldsRoot 'solution\.codex\config.toml'),
        (Join-Path $scaffoldReferences 'portfolio\.codex\config.toml'),
        (Join-Path $scaffoldReferences 'solution\.codex\config.toml')
    )
    foreach ($configPath in $configPaths) {
        if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) { continue }
        $configText = Get-Content -Raw -LiteralPath $configPath
        $featuresMatch = [regex]::Match($configText, '(?ms)^\[features\]\s*\r?\n(?<body>.*?)(?=^\[|\z)')
        if (-not $featuresMatch.Success -or $featuresMatch.Groups['body'].Value -notmatch '(?m)^multi_agent\s*=\s*true\s*$' -or $featuresMatch.Groups['body'].Value -notmatch '(?m)^multi_agent_v2\s*=\s*true\s*$' -or $featuresMatch.Groups['body'].Value -notmatch '(?m)^shell_tool\s*=\s*true\s*$') {
            Add-Failure "Codex config must enable multi_agent, the repository-required multi_agent_v2 workflow, and shell_tool: $configPath"
        }
    }
    $rootConfigPath = Join-Path $workspaceRoot '.codex\config.toml'
    if (Test-Path -LiteralPath $rootConfigPath -PathType Leaf) {
        $rootConfigText = Get-Content -Raw -LiteralPath $rootConfigPath
        $warningMatch = [regex]::Match($rootConfigText, '(?m)^suppress_unstable_features_warning\s*=\s*true\s*$')
        $firstSectionMatch = [regex]::Match($rootConfigText, '(?m)^\[')
        if (-not $warningMatch.Success -or ($firstSectionMatch.Success -and $warningMatch.Index -gt $firstSectionMatch.Index)) {
            Add-Failure "Root warning-suppression setting must be a top-level key: $rootConfigPath"
        }
    }

    $availableSkillNames = @(Get-ChildItem -LiteralPath (Join-Path $workspaceRoot 'plugins') -Directory | ForEach-Object {
        $packageSkills = Join-Path $_.FullName 'skills'
        if (Test-Path -LiteralPath $packageSkills -PathType Container) {
            Get-ChildItem -LiteralPath $packageSkills -Directory | ForEach-Object Name
        }
    } | Sort-Object -Unique)
    $sourceAgentFiles = @(Get-ChildItem -LiteralPath $sourceScaffoldsRoot -Recurse -File -Filter '*.toml' | Where-Object { $_.FullName -match '[\\/]\.codex[\\/]agents[\\/]' })
    foreach ($agentFile in $sourceAgentFiles) {
        $agentText = Get-Content -Raw -LiteralPath $agentFile.FullName
        foreach ($allocation in [regex]::Matches($agentText, '\$([a-z][a-z0-9-]+)')) {
            $allocatedSkill = $allocation.Groups[1].Value
            if ($availableSkillNames -notcontains $allocatedSkill) { Add-Failure "Agent allocation references a missing skill '$allocatedSkill': $($agentFile.FullName)" }
        }
    }

    $implementationAgentNames = @('solution-developer.toml', 'package-developer.toml', 'module-developer.toml', 'integration-engineer.toml', 'azure-engineer.toml', 'azure-db-developer.toml', 'csharp-developer.toml', 'full-stack-developer.toml', 'maf-developer.toml', 'ui-designer.toml')
    $solutionAgentRoot = Join-Path $sourceScaffoldsRoot 'solution\.codex\agents\swe'
    foreach ($agentName in $implementationAgentNames) {
        $agentPath = Join-Path $solutionAgentRoot $agentName
        if ((Get-Content -Raw -LiteralPath $agentPath) -match [regex]::Escape('$swe-validate')) { Add-Failure "Implementation role must not own formal validation: $agentPath" }
    }
    $solutionValidatorPath = Join-Path $solutionAgentRoot 'solution-validator.toml'
    if (-not (Test-Path -LiteralPath $solutionValidatorPath -PathType Leaf) -or (Get-Content -Raw -LiteralPath $solutionValidatorPath) -notmatch [regex]::Escape('$swe-validate')) {
        Add-Failure 'Solution scaffold must register an independent solution-validator allocated to $swe-validate.'
    }

    $portfolioPlatformPath = Join-Path $sourceScaffoldsRoot 'portfolio\.codex\agents\swe\platform-engineer.toml'
    if ((Get-Content -Raw -LiteralPath $portfolioPlatformPath) -match [regex]::Escape('$swe-validate')) {
        Add-Failure "Portfolio implementation role must not own formal validation: $portfolioPlatformPath"
    }

    foreach ($reviewerPath in @(
        (Join-Path $sourceScaffoldsRoot 'portfolio\.codex\agents\swe\architecture-reviewer.toml'),
        (Join-Path $sourceScaffoldsRoot 'solution\.codex\agents\swe\architecture-reviewer.toml')
    )) {
        $reviewerText = Get-Content -Raw -LiteralPath $reviewerPath
        if ($reviewerText -notmatch [regex]::Escape('$swe-architect -review') -or $reviewerText -match [regex]::Escape('$swe-validate')) {
            Add-Failure "Architecture reviewer must use `$swe-architect -review and must not use `$swe-validate: $reviewerPath"
        }
    }

    $portfolioIntegrationPath = Join-Path $sourceScaffoldsRoot 'portfolio\.codex\agents\swe\integration-engineer.toml'
    $portfolioIntegrationText = Get-Content -Raw -LiteralPath $portfolioIntegrationPath
    foreach ($forbiddenAllocation in @('$swe-design', '$swe-implement', '$swe-validate')) {
        if ($portfolioIntegrationText -match [regex]::Escape($forbiddenAllocation)) { Add-Failure "Portfolio integration role crosses child authority with ${forbiddenAllocation}: $portfolioIntegrationPath" }
    }

    foreach ($governancePath in @((Join-Path $sourceScaffoldsRoot 'portfolio\AGENTS.md'), (Join-Path $sourceScaffoldsRoot 'solution\AGENTS.md'))) {
        $governanceText = Get-Content -Raw -LiteralPath $governancePath
        if ($governanceText -notmatch [regex]::Escape('## Phase and Role Matrix')) { Add-Failure "Scaffold governance lacks the phase and role matrix: $governancePath" }
    }
}

$scaffoldScript = Join-Path $skillsRoot 'swe-scaffold\scripts\Invoke-SweScaffold.ps1'
if (-not (Test-Path -LiteralPath $scaffoldScript -PathType Leaf)) {
    Add-Failure "Missing scaffold merge script: $scaffoldScript"
} elseif (-not $SkipBehaviorTests) {
    $tempBase = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\', '/')
    $tempRoot = Join-Path $tempBase ('swe-process-validation-' + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $tempRoot | Out-Null
    try {
        $mergeDestination = Join-Path $tempRoot 'merge'
        New-Item -ItemType Directory -Path $mergeDestination | Out-Null
        $sentinelPath = Join-Path $mergeDestination 'README.md'
        [System.IO.File]::WriteAllText($sentinelPath, 'preserve-me')
        $firstReport = & $scaffoldScript -Solution -Destination $mergeDestination
        if ($firstReport.SchemaVersion -ne '2.0' -or $firstReport.Scaffold -ne 'solution') { Add-Failure 'Scaffold report schema is not programmatically stable.' }
        if ((Get-Content -Raw -LiteralPath $sentinelPath) -ne 'preserve-me') { Add-Failure 'Scaffold merge overwrote an existing file.' }
        if ($firstReport.SkippedExistingFiles -notcontains 'README.md') { Add-Failure 'Scaffold merge did not report an existing file as skipped.' }
        if (($firstReport.Counts.Created + $firstReport.Counts.SkippedExisting) -ne $firstReport.Counts.TotalSourceFiles) { Add-Failure 'Scaffold first-run accounting is incomplete.' }

        $secondReport = & $scaffoldScript -Solution -Destination $mergeDestination
        if ($secondReport.Counts.Created -ne 0 -or $secondReport.Counts.SkippedExisting -ne $secondReport.Counts.TotalSourceFiles) { Add-Failure 'Scaffold rerun is not no-clobber idempotent.' }
        $jsonReport = (& $scaffoldScript -Solution -Destination $mergeDestination -AsJson) | Out-String | ConvertFrom-Json
        if ($jsonReport.SchemaVersion -ne '2.0' -or $jsonReport.Counts.TotalSourceFiles -ne $secondReport.Counts.TotalSourceFiles) { Add-Failure 'Scaffold JSON report is invalid.' }

        $portfolioDestination = Join-Path $tempRoot 'portfolio'
        New-Item -ItemType Directory -Path $portfolioDestination | Out-Null
        $portfolioReport = & $scaffoldScript -Portfolio -Destination $portfolioDestination
        if ($portfolioReport.SchemaVersion -ne '2.0' -or $portfolioReport.Scaffold -ne 'portfolio') { Add-Failure 'Portfolio scaffold report schema is not programmatically stable.' }
        Test-ContextLayout -ScaffoldRoot $portfolioDestination -ScaffoldName 'portfolio'

        $legacyDestination = Join-Path $tempRoot 'legacy-portfolio'
        New-Item -ItemType Directory -Path $legacyDestination | Out-Null
        $legacyContextPath = Join-Path $legacyDestination 'WORK-CONTEXT.md'
        [System.IO.File]::WriteAllText($legacyContextPath, 'legacy-context')
        $legacyFailed = $false
        $legacyFailureMessage = ''
        try { $null = & $scaffoldScript -Portfolio -Destination $legacyDestination } catch {
            $legacyFailed = $true
            $legacyFailureMessage = $_.Exception.Message
        }
        if (-not $legacyFailed -or $legacyFailureMessage -notmatch 'Legacy portfolio context layout') { Add-Failure 'Portfolio scaffold did not clearly reject the legacy root context layout.' }
        if ((Get-ChildItem -LiteralPath $legacyDestination -Force).Count -ne 1 -or (Get-Content -Raw -LiteralPath $legacyContextPath) -ne 'legacy-context') {
            Add-Failure 'Legacy portfolio context preflight changed the destination or left partial output.'
        }

        $collisionDestination = Join-Path $tempRoot 'collision'
        New-Item -ItemType Directory -Path $collisionDestination | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $collisionDestination '.codex'), 'file-collision')
        $collisionFailed = $false
        try { $null = & $scaffoldScript -Solution -Destination $collisionDestination } catch { $collisionFailed = $true }
        if (-not $collisionFailed) { Add-Failure 'Scaffold merge did not fail on a directory/file type collision.' }
        if ((Get-ChildItem -LiteralPath $collisionDestination -Force).Count -ne 1) { Add-Failure 'Scaffold collision preflight left partial output.' }
    } finally {
        $resolvedTempRoot = [System.IO.Path]::GetFullPath($tempRoot)
        if ($resolvedTempRoot.StartsWith($tempBase, [System.StringComparison]::OrdinalIgnoreCase) -and (Split-Path -Leaf $resolvedTempRoot) -like 'swe-process-validation-*') {
            [System.IO.Directory]::Delete($resolvedTempRoot, $true)
        }
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) { [Console]::Error.WriteLine("ERROR: $failure") }
    exit 1
}

Write-Output "Validated 13 skills, 18 canonical templates, lifecycle/config/role semantics, phase gates, scaffold behavior, agent registries, and available source/reference parity at $PluginRoot"
