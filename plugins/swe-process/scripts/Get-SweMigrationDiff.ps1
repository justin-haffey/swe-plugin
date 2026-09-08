[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Destination,
    [Parameter(Mandatory = $true)][string]$Proposed,
    [string]$Baseline,
    [switch]$IncludeContent,
    [switch]$AsJson
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# This helper is deliberately read-only: applying a proposal is a separate authorized operation.
function Get-TreeRoot([string]$Path) {
    $item = Get-Item -LiteralPath $Path -Force
    if (-not $item.PSIsContainer) { throw "Tree root must be a directory: $Path" }
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw "Linked tree roots are unsupported: $Path" }
    if ($item.FullName -eq [IO.Path]::GetPathRoot($item.FullName)) { throw "Select a repository or scaffold directory, not a filesystem root: $Path" }
    return $item.FullName.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
}

function Get-TreeEntries([string]$Root) {
    $entries = @{}
    if (-not $Root) { return $entries }
    $queue = New-Object 'System.Collections.Generic.Queue[string]'
    $queue.Enqueue($Root)
    while ($queue.Count -gt 0) {
        foreach ($item in Get-ChildItem -LiteralPath $queue.Dequeue() -Force) {
            $relative = $item.FullName.Substring($Root.Length + 1).Replace('\', '/')
            # Git internals never belong to a scaffold comparison.
            if ($relative -eq '.git' -or $relative.StartsWith('.git/')) { continue }
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                $entries[$relative] = @{ Kind = 'Link'; Path = $item.FullName; Hash = $null }
            } elseif ($item.PSIsContainer) {
                $entries[$relative] = @{ Kind = 'Directory'; Path = $item.FullName; Hash = $null }
                $queue.Enqueue($item.FullName)
            } else {
                $entries[$relative] = @{ Kind = 'File'; Path = $item.FullName; Hash = (Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256).Hash }
            }
        }
    }
    return $entries
}

function Test-SameEntry($Left, $Right) {
    if ($null -eq $Left -or $null -eq $Right) { return ($null -eq $Left -and $null -eq $Right) }
    return ($Left.Kind -eq $Right.Kind -and $Left.Kind -ne 'Link' -and $Left.Hash -eq $Right.Hash)
}

$destinationRoot = Get-TreeRoot $Destination
$proposedRoot = Get-TreeRoot $Proposed
$baselineRoot = if ($Baseline) { Get-TreeRoot $Baseline } else { $null }
$currentEntries = Get-TreeEntries $destinationRoot
$proposedEntries = Get-TreeEntries $proposedRoot
$baselineEntries = Get-TreeEntries $baselineRoot
$paths = @(@($currentEntries.Keys) + @($proposedEntries.Keys) + @($baselineEntries.Keys) | Sort-Object -Unique)
$changes = @(
    foreach ($path in $paths) {
        $current = $currentEntries[$path]
        $next = $proposedEntries[$path]
        $prior = $baselineEntries[$path]
        $kinds = @(@($current, $next, $prior) | Where-Object { $null -ne $_ } | ForEach-Object { $_.Kind } | Select-Object -Unique)
        $classification = if ($kinds -contains 'Link' -or $kinds.Count -gt 1) { 'TypeCollision' }
        elseif (Test-SameEntry $current $next) { 'Unchanged' }
        elseif (-not $baselineRoot) { if (-not $current) { 'ProposedAddition' } elseif (-not $next) { 'CustomOnly' } else { 'BaselineUnknown' } }
        elseif (-not $prior -and -not $next) { 'CustomOnly' }
        elseif (-not $prior -and -not $current) { 'ProposedAddition' }
        elseif (-not $next) { if (Test-SameEntry $current $prior) { 'RetiredRequirementRetainFile' } else { 'CustomizedRetiredFile' } }
        elseif (Test-SameEntry $current $prior) { 'ProposedUpdate' }
        elseif (Test-SameEntry $next $prior) { 'PreserveCustomization' }
        else { 'CustomizationConflict' }
        $row = [ordered]@{
            Path = $path
            Classification = $classification
            Action = if ($classification -in @('ProposedAddition', 'ProposedUpdate')) { 'ReviewProposal' } elseif ($classification -in @('TypeCollision', 'BaselineUnknown', 'CustomizationConflict', 'CustomizedRetiredFile')) { 'ResolveOwnership' } else { 'Preserve' }
            BaselineKind = if ($prior) { $prior.Kind } else { $null }
            CurrentKind = if ($current) { $current.Kind } else { $null }
            ProposedKind = if ($next) { $next.Kind } else { $null }
            BaselineSha256 = if ($prior) { $prior.Hash } else { $null }
            CurrentSha256 = if ($current) { $current.Hash } else { $null }
            ProposedSha256 = if ($next) { $next.Hash } else { $null }
        }
        if ($IncludeContent) {
            foreach ($entryName in @('Baseline', 'Current', 'Proposed')) {
                $entry = switch ($entryName) { 'Baseline' { $prior } 'Current' { $current } 'Proposed' { $next } }
                $row[$entryName + 'Content'] = if ($entry -and $entry.Kind -eq 'File') { [IO.File]::ReadAllText($entry.Path) } else { $null }
            }
        }
        [pscustomobject]$row
    }
)
$report = [pscustomobject][ordered]@{
    SchemaVersion = '3.0'
    Mode = 'DryRun'
    Destination = $destinationRoot
    Baseline = $baselineRoot
    Proposed = $proposedRoot
    DestinationWrites = 0
    PolicyActivated = $false
    Changes = $changes
}
if ($AsJson) { $report | ConvertTo-Json -Depth 8 } else { $report }
