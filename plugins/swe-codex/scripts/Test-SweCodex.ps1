[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$script:Failures = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([Parameter(Mandatory)][string]$Message)
    $script:Failures.Add($Message)
}

$pluginRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $pluginRoot '.codex-plugin\plugin.json'
$hookConfigPath = Join-Path $pluginRoot 'hooks\hooks.json'
$hookScriptPath = Join-Path $pluginRoot 'hooks\goal-complete.mjs'
$skillRoot = Join-Path $pluginRoot 'skills\repo-wrap-up'
$skillPath = Join-Path $skillRoot 'SKILL.md'
$uiPath = Join-Path $skillRoot 'agents\openai.yaml'
$reviewContractPath = Join-Path $skillRoot 'references\REVIEW-HANDOFF.md'

foreach ($path in @($manifestPath, $hookConfigPath, $hookScriptPath, $skillPath, $uiPath, $reviewContractPath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        Add-Failure "Missing required SWE Codex resource: $path"
    }
}

if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
    try {
        $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
        if ($manifest.name -ne 'swe-codex' -or $manifest.version -ne '2.0.2') {
            Add-Failure "SWE Codex manifest identity or version is invalid: $manifestPath"
        }
        if ($manifest.author.name -ne 'Ghostworx.ai, LLC' -or $manifest.interface.developerName -ne 'Ghostworx.ai, LLC') {
            Add-Failure "SWE Codex manifest publisher is invalid: $manifestPath"
        }
        if ($manifest.PSObject.Properties.Name -contains 'hooks') {
            Add-Failure "SWE Codex hooks must use default hooks/hooks.json discovery, not a manifest field: $manifestPath"
        }
        if (@($manifest.interface.defaultPrompt).Count -gt 3) {
            Add-Failure "SWE Codex interface.defaultPrompt supports at most three entries: $manifestPath"
        }
    } catch {
        Add-Failure "Invalid SWE Codex manifest JSON: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $hookConfigPath -PathType Leaf) {
    try {
        $hookConfig = Get-Content -Raw -LiteralPath $hookConfigPath | ConvertFrom-Json
        $groups = @($hookConfig.hooks.PostToolUse)
        if ($groups.Count -ne 1 -or $groups[0].matcher -ne '^update_goal$') {
            Add-Failure "Goal closeout hook must match only update_goal: $hookConfigPath"
        } else {
            $handlers = @($groups[0].hooks)
            if ($handlers.Count -ne 1 -or $handlers[0].type -ne 'command') {
                Add-Failure "Goal closeout hook must define one command handler: $hookConfigPath"
            }
            if ($handlers[0].command -notmatch 'goal-complete\.mjs' -or $handlers[0].commandWindows -notmatch 'goal-complete\.mjs') {
                Add-Failure "Goal closeout hook must define portable and Windows commands: $hookConfigPath"
            }
        }
    } catch {
        Add-Failure "Invalid goal closeout hook JSON: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath $skillPath -PathType Leaf) {
    $skillText = Get-Content -Raw -LiteralPath $skillPath
    if ($skillText -notmatch '(?s)^---\s*\r?\nname:\s*repo-wrap-up\s*\r?\ndescription:\s*.+?\r?\n---') {
        Add-Failure "repo-wrap-up front matter is invalid: $skillPath"
    }
    foreach ($requiredText in @('repo-author', 'built-in `worker`', 'BUILT_IN_WORKER_FALLBACK', 'must not delegate again', 'references/REVIEW-HANDOFF.md', 'git diff --check', 'Do not stage or commit')) {
        if ($skillText -notmatch [regex]::Escape($requiredText)) {
            Add-Failure "repo-wrap-up is missing '$requiredText': $skillPath"
        }
    }
}

if (Test-Path -LiteralPath $uiPath -PathType Leaf) {
    $uiText = Get-Content -Raw -LiteralPath $uiPath
    if ($uiText -notmatch [regex]::Escape('$repo-wrap-up') -or $uiText -notmatch '(?m)^\s*allow_implicit_invocation:\s*true\s*$') {
        Add-Failure "repo-wrap-up UI metadata is invalid: $uiPath"
    }
}

$node = Get-Command node -ErrorAction SilentlyContinue
if ($null -eq $node) {
    Add-Failure 'Node.js is required to validate the goal-complete hook handler.'
} elseif (Test-Path -LiteralPath $hookScriptPath -PathType Leaf) {
    $completeInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"complete"},"tool_response":{"goal":{"objective":"Document completed work","status":"complete"},"remainingTokens":1200,"completionBudgetReport":null}}'
    $completeOutput = $completeInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0) {
        Add-Failure "goal-complete handler failed for completion input with exit code $LASTEXITCODE"
    } else {
        try {
            $completeJson = $completeOutput | ConvertFrom-Json
            $context = $completeJson.hookSpecificOutput.additionalContext
            if ($completeJson.hookSpecificOutput.hookEventName -ne 'PostToolUse' -or $context -notmatch [regex]::Escape('$repo-wrap-up') -or $context -notmatch 'repo-author' -or $context -notmatch 'worker' -or $context -notmatch 'Do not stage or commit') {
                Add-Failure 'goal-complete handler did not emit the required closeout context.'
            }
        } catch {
            Add-Failure "goal-complete handler emitted invalid JSON: $($_.Exception.Message)"
        }
    }

    $activeInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"blocked"},"tool_response":{"status":"blocked"}}'
    $activeOutput = $activeInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrWhiteSpace(($activeOutput -join ''))) {
        Add-Failure 'goal-complete handler must emit nothing for a non-complete goal update.'
    }

    $failedInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"complete"},"tool_response":{"isError":true}}'
    $failedOutput = $failedInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrWhiteSpace(($failedOutput -join ''))) {
        Add-Failure 'goal-complete handler must emit nothing for a failed goal completion.'
    }

    $missingResponseInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"complete"}}'
    $missingResponseOutput = $missingResponseInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrWhiteSpace(($missingResponseOutput -join ''))) {
        Add-Failure 'goal-complete handler must emit nothing when goal completion response evidence is missing.'
    }

    $incompleteGoalInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"complete"},"tool_response":{"goal":{"status":"active"}}}'
    $incompleteGoalOutput = $incompleteGoalInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0 -or -not [string]::IsNullOrWhiteSpace(($incompleteGoalOutput -join ''))) {
        Add-Failure 'goal-complete handler must emit nothing unless response goal status is complete.'
    }

    $structuredInput = '{"hook_event_name":"PostToolUse","tool_name":"update_goal","tool_input":{"status":"complete"},"tool_response":{"structuredContent":{"goal":{"status":"complete"}}}}'
    $structuredOutput = $structuredInput | & $node.Source $hookScriptPath
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($structuredOutput -join ''))) {
        Add-Failure 'goal-complete handler must recognize a completed goal in structuredContent.'
    }
}

if ($script:Failures.Count -gt 0) {
    $script:Failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output 'SWE Codex validation passed.'
