# Shared mechanical readers. They never infer approval or execute artifact text.
function Get-SweField($Object, [string]$Name, $Default = $null) {
    if ($null -ne $Object -and $null -ne $Object.PSObject.Properties[$Name]) { return $Object.$Name }
    return $Default
}
function Resolve-SweLocalFile([string]$Repository, [string]$Path) {
    if (-not [IO.Path]::IsPathRooted($Repository) -or [IO.Path]::IsPathRooted($Path)) { throw 'Expected an absolute repository and relative file path.' }
    $root = [IO.Path]::GetFullPath($Repository).TrimEnd('\','/')
    $file = [IO.Path]::GetFullPath((Join-Path $root $Path))
    if (-not $file.StartsWith($root + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'File escapes repository.' }
    $cursor = Get-Item -LiteralPath $file -Force -ErrorAction Stop
    if ($cursor.PSIsContainer) { throw 'Expected a file.' }
    while ($null -ne $cursor) {
        if ($cursor.Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Linked artifact paths are unsupported.' }
        $cursor = if ($cursor -is [IO.FileInfo]) { $cursor.Directory } else { $cursor.Parent }
    }
    return $file
}
function Get-SweArtifactLocator($Address, [string]$DefaultRepository) {
    $repo = Get-SweField $Address 'repository' $DefaultRepository
    $path = Resolve-SweLocalFile $repo (Get-SweField $Address 'path')
    $bytes = [IO.File]::ReadAllBytes($path)
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $hash = [BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-','') } finally { $sha.Dispose() }
    $content = [Text.Encoding]::UTF8.GetString($bytes).TrimStart([char]0xFEFF)
    $header = [regex]::Match($content, '(?ms)\A---\s*\r?\n(?<body>.*?)\r?\n---')
    $ids = [regex]::Matches($header.Groups['body'].Value, '(?m)^id:\s*(?:"(?<id>[^"]+)"|''(?<id>[^'']+)''|(?<id>[^\r\n#]+))\s*$')
    if (-not $header.Success -or $ids.Count -ne 1) { throw "Missing or ambiguous canonical artifact ID: $path" }
    $id = $ids[0].Groups['id'].Value.Trim()
    $expectedId = Get-SweField $Address 'artifact_id'
    $expectedHash = Get-SweField $Address 'sha256'
    if ($expectedId -and $expectedId -cne $id) { throw "Artifact identity changed: $path" }
    if ($expectedHash -and $expectedHash -ne $hash) { throw "Previously frozen artifact changed: $path" }
    $locator = [ordered]@{ repository = [IO.Path]::GetFullPath($repo).TrimEnd('\','/'); path = $path.Substring(([IO.Path]::GetFullPath($repo).TrimEnd('\','/')).Length + 1).Replace('\','/'); artifact_id = $id; sha256 = $hash }
    if (Get-SweField $Address 'revision') { $locator.revision = $Address.revision }
    return [pscustomobject]@{ locator = [pscustomobject]$locator; text = $content }
}
