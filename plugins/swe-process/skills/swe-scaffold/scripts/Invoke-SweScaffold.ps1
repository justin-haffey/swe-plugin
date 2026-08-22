[CmdletBinding(DefaultParameterSetName = 'Portfolio')]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Portfolio')]
    [switch]$Portfolio,

    [Parameter(Mandatory = $true, ParameterSetName = 'Solution')]
    [switch]$Solution,

    [Parameter()]
    [string]$Destination = (Get-Location).Path,

    [Parameter()]
    [switch]$AsJson
)

$ErrorActionPreference = 'Stop'

$skillRoot = Split-Path -Parent $PSScriptRoot
$scaffoldName = if ($Portfolio) { 'portfolio' } else { 'solution' }
$sourceRoot = Join-Path (Join-Path $skillRoot 'references') $scaffoldName

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) {
    throw "Scaffold reference tree not found: $sourceRoot"
}
if (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
    throw "Destination directory not found: $Destination"
}

$resolvedSource = (Resolve-Path -LiteralPath $sourceRoot).Path.TrimEnd('\', '/')
$resolvedDestination = (Resolve-Path -LiteralPath $Destination).Path.TrimEnd('\', '/')
$sourceDirectories = @(Get-ChildItem -LiteralPath $resolvedSource -Force -Recurse -Directory | Sort-Object FullName)
$sourceFiles = @(Get-ChildItem -LiteralPath $resolvedSource -Force -Recurse -File | Sort-Object FullName)

function Get-TargetPath {
    param([Parameter(Mandatory = $true)][string]$SourcePath)

    $relative = $SourcePath.Substring($resolvedSource.Length).TrimStart('\', '/')
    [pscustomobject]@{
        Relative = $relative
        Target = Join-Path $resolvedDestination $relative
    }
}

# Preflight the complete tree before writing so a file/directory type collision
# cannot leave a partially merged scaffold.
foreach ($directory in $sourceDirectories) {
    $target = Get-TargetPath -SourcePath $directory.FullName
    if ((Test-Path -LiteralPath $target.Target) -and -not (Test-Path -LiteralPath $target.Target -PathType Container)) {
        throw "Scaffold type collision: source directory '$($target.Relative)' maps to a destination file."
    }
}
foreach ($file in $sourceFiles) {
    $target = Get-TargetPath -SourcePath $file.FullName
    if ((Test-Path -LiteralPath $target.Target) -and -not (Test-Path -LiteralPath $target.Target -PathType Leaf)) {
        throw "Scaffold type collision: source file '$($target.Relative)' maps to a destination directory."
    }
}

$createdDirectories = [System.Collections.Generic.List[string]]::new()
$createdFiles = [System.Collections.Generic.List[string]]::new()
$skippedFiles = [System.Collections.Generic.List[string]]::new()

foreach ($directory in $sourceDirectories) {
    $target = Get-TargetPath -SourcePath $directory.FullName
    if (-not (Test-Path -LiteralPath $target.Target -PathType Container)) {
        New-Item -ItemType Directory -Path $target.Target | Out-Null
        $createdDirectories.Add($target.Relative)
    }
}

foreach ($file in $sourceFiles) {
    $target = Get-TargetPath -SourcePath $file.FullName

    if (Test-Path -LiteralPath $target.Target -PathType Leaf) {
        $skippedFiles.Add($target.Relative)
        continue
    }
    if (Test-Path -LiteralPath $target.Target) {
        throw "Scaffold type collision detected during copy: '$($target.Relative)'."
    }

    $targetParent = Split-Path -Parent $target.Target
    if ((Test-Path -LiteralPath $targetParent) -and -not (Test-Path -LiteralPath $targetParent -PathType Container)) {
        throw "Scaffold type collision: parent for '$($target.Relative)' is not a directory."
    }
    if (-not (Test-Path -LiteralPath $targetParent -PathType Container)) {
        New-Item -ItemType Directory -Path $targetParent | Out-Null
    }

    $temporaryPath = Join-Path $targetParent ('.swe-scaffold-' + [guid]::NewGuid().ToString('N') + '.tmp')
    $sourceStream = $null
    $temporaryStream = $null
    try {
        $sourceStream = [System.IO.File]::Open($file.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
        $temporaryStream = [System.IO.File]::Open($temporaryPath, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
        $sourceStream.CopyTo($temporaryStream)
        $temporaryStream.Flush()
        $temporaryStream.Dispose()
        $temporaryStream = $null
        $sourceStream.Dispose()
        $sourceStream = $null

        try {
            [System.IO.File]::Move($temporaryPath, $target.Target)
            $createdFiles.Add($target.Relative)
        } catch [System.IO.IOException] {
            if (Test-Path -LiteralPath $target.Target -PathType Leaf) {
                Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
                $skippedFiles.Add($target.Relative)
            } elseif (Test-Path -LiteralPath $target.Target) {
                throw "Scaffold type collision detected during atomic move: '$($target.Relative)'."
            } else {
                throw
            }
        }
    } finally {
        if ($null -ne $temporaryStream) { $temporaryStream.Dispose() }
        if ($null -ne $sourceStream) { $sourceStream.Dispose() }
        if (Test-Path -LiteralPath $temporaryPath -PathType Leaf) {
            Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
        }
    }
}

$report = [pscustomobject]@{
    SchemaVersion = '2.0'
    Scaffold = $scaffoldName
    Destination = $resolvedDestination
    CreatedFiles = [string[]]$createdFiles
    SkippedExistingFiles = [string[]]$skippedFiles
    CreatedDirectories = [string[]]$createdDirectories
    Counts = [pscustomobject]@{
        Created = $createdFiles.Count
        SkippedExisting = $skippedFiles.Count
        TotalSourceFiles = $sourceFiles.Count
    }
}

if ($AsJson) {
    $report | ConvertTo-Json -Depth 5
} else {
    $report
}
