[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Repository,
    [Parameter(Mandatory)][string]$Path,
    [string]$RepositoryMapPath
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Swe-ArtifactFields.ps1')
$repositoryMap = if ($RepositoryMapPath) { Get-Content -Raw -LiteralPath $RepositoryMapPath | ConvertFrom-Json } else { [pscustomobject]@{} }
$records = [Collections.Generic.List[object]]::new()
$visited = @{}; $visiting = @{}
function Visit($Address, [string]$OwningRepository) {
    $repositoryId = Get-SweField $Address 'repository'
    $targetRepository = $OwningRepository
    if ($repositoryId) {
        # All foreign repositories require an explicit mapping, including absolute
        # identifiers. Artifact content cannot authorize filesystem expansion.
        $mapped = Get-SweField $repositoryMap $repositoryId
        if (-not $mapped) { throw "Unmapped cross-repository identity: $repositoryId" }
        $targetRepository = $mapped
    }
    $resolved = Get-SweArtifactLocator ([pscustomobject]@{
        path = $Address.path; artifact_id = (Get-SweField $Address 'artifact_id');
        revision = (Get-SweField $Address 'revision'); sha256 = (Get-SweField $Address 'sha256')
    }) $targetRepository
    $key = $resolved.locator.repository + '|' + $resolved.locator.path
    if ($visiting.ContainsKey($key)) { throw "Cyclic artifact relationship: $key" }
    if ($visited.ContainsKey($key)) { return }
    $visiting[$key] = $true
    $header = [regex]::Match($resolved.text, '(?ms)\A---\s*\r?\n(?<body>.*?)\r?\n---').Groups['body'].Value
    $links = @()
    if ($header -match '(?m)^schema_version:\s*4\s*$') {
        $matches = [regex]::Matches($header, '(?m)^links:\s*(\[[^\r\n]*\])\s*$')
        if ($matches.Count -ne 1) { throw 'V4 links must be one compact JSON-compatible YAML array; use the artifact generator.' }
        # Assign the JSON array directly: Windows PowerShell otherwise wraps it
        # as a single pipeline item, including an empty root links array.
        $links = ConvertFrom-Json -InputObject $matches[0].Groups[1].Value
        foreach ($link in $links) {
            if (-not (Get-SweField $link 'relation') -or -not (Get-SweField $link 'artifact_id') -or -not (Get-SweField $link 'path')) { throw 'Incomplete direct artifact link.' }
        }
    } else {
        # Legacy full headers remain readable without rewriting accepted history.
        $upstream = [regex]::Match($header, '(?ms)^upstream:\s*\r?\n(?<body>.*?)(?=^[^\s#]|\z)')
        if ($upstream.Success) {
            $link = [ordered]@{ relation = 'upstream' }
            foreach ($field in @('repository','artifact_id','path','revision')) {
                $value = [regex]::Match($upstream.Groups['body'].Value, ('(?m)^\s+' + $field + ':\s*["'']?(?<value>[^\r\n"'']+)["'']?\s*$'))
                if ($value.Success) { $link[$field] = $value.Groups['value'].Value.Trim() }
            }
            if (-not $link.artifact_id -or -not $link.path) { throw 'Incomplete legacy upstream locator.' }
            $links = @([pscustomobject]$link)
        }
    }
    $records.Add([pscustomobject]@{ locator = $resolved.locator; direct_links = $links })
    foreach ($link in $links) { Visit $link $resolved.locator.repository }
    $visiting.Remove($key); $visited[$key] = $true
}
Visit ([pscustomobject]@{ path = $Path }) $Repository
[pscustomobject]@{ schema = 'swe-lineage/v1'; artifacts = @($records); grants_acceptance = $false; writes = 0 } | ConvertTo-Json -Depth 30
