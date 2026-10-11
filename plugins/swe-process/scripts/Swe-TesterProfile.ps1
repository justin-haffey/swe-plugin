# Model selection has one authority: the selected native role configuration.
function Get-SweTesterProfile([string]$Repository) {
    $role = Join-Path $PSScriptRoot '../scaffolds/solution/.codex/agents/swe/test-runner.toml'
    $config = Join-Path $Repository '.codex/config.toml'
    if (Test-Path -LiteralPath $config -PathType Leaf) {
        $text = [IO.File]::ReadAllText($config)
        $section = [regex]::Matches($text, '(?ms)^\[agents\.test_runner\]\s*\r?\n(.*?)(?=^\[|\z)')
        if ($section.Count -ne 1) { throw 'Native test_runner registration is missing or ambiguous.' }
        $path = [regex]::Matches($section[0].Groups[1].Value, '(?m)^config_file\s*=\s*"([^"\r\n]+)"\s*$')
        if ($path.Count -ne 1) { throw 'Tester config_file requires the native TOML resolver.' }
        $configRoot = [IO.Path]::GetFullPath((Split-Path -Parent $config))
        $role = [IO.Path]::GetFullPath((Join-Path $configRoot $path[0].Groups[1].Value))
        if (-not $role.StartsWith($configRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Tester role escapes the native configuration directory.' }
    }
    # For bounded fixtures without a registry use the shipped role explicitly;
    # this does not attest host capability or install/adopt repository governance.
    $text = [IO.File]::ReadAllText($role)
    $values = @{}
    foreach ($key in @('name','model','model_reasoning_effort')) {
        $matches = [regex]::Matches($text, ('(?m)^' + $key + '\s*=\s*"([^"\r\n]+)"\s*$'))
        if ($matches.Count -ne 1) { throw "Tester role setting is missing or ambiguous: $key" }
        $values[$key] = $matches[0].Groups[1].Value
    }
    if ($values.name -ne 'test-runner') { throw 'Selected role is not test-runner.' }
    [pscustomobject]@{ role = 'test-runner'; model = $values.model; reasoning_effort = $values.model_reasoning_effort; path = [IO.Path]::GetFullPath($role) }
}
