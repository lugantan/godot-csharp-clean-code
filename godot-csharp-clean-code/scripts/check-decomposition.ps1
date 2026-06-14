#!/usr/bin/env pwsh
#
# check-decomposition.ps1 — hard gate for the godot-csharp-clean-code skill.
#
# Enforces two rules that a human (or an LLM) will otherwise erode over time:
#   1. NO hand-written `partial` split: one class = one hand-written .cs file.
#   2. NO oversized files: a single .cs file may not exceed -MaxLines lines.
#
# Why rule 1 exists (the part people get wrong):
#   A `partial class` is ONE type. The compiler merges every partial file into a
#   single class with one shared set of private fields and methods. Splitting it
#   across HeroController.cs + HeroController.Combat.cs does NOT reduce coupling,
#   surface area, or responsibility — every member still sees every other member,
#   and the unit you must reason about and test is still the whole merged type.
#   You only hide the growth from your size signals. The fix is to EXTRACT a real
#   collaborator (e.g. a pure-C# CombatResolver), not to add another partial half.
#
# Godot note: Godot 4.x REQUIRES a single `partial` on every Node-/Resource-derived
# class so its source generator can emit the companion half. That generated half
# lives in obj/ as *.g.cs and is excluded below, so a correctly-written engine type
# appears in exactly ONE source file and passes. This gate only flags a SECOND
# hand-written file for the same type.
#
# Usage:
#   pwsh scripts/check-decomposition.ps1 -Path . -MaxLines 1000
# Exit code 0 = clean, 1 = violations (suitable for CI).

[CmdletBinding()]
param(
    [string]$Path = ".",
    [int]$MaxLines = 1000
)

$ErrorActionPreference = 'Stop'

# Build output and generator output are not hand-written source — never gate them.
$excludeDirRegex  = '[\\/](obj|bin|\.godot|\.git|addons|node_modules)[\\/]'
$excludeFileRegex = '\.(g|generated|designer)\.cs$'

$files = Get-ChildItem -Path $Path -Recurse -Filter *.cs -File |
    Where-Object {
        $_.FullName -notmatch $excludeDirRegex -and
        $_.Name     -notmatch $excludeFileRegex
    }

# Match: [modifiers] partial (class|struct|record|interface) Name
$partialDeclRegex = '\bpartial\s+(class|struct|record|interface)\s+([A-Za-z_]\w*)'

$partials  = @{}   # "kind Name" -> HashSet<file>
$oversized = @()

foreach ($f in $files) {
    $lines = @(Get-Content -LiteralPath $f.FullName)
    if ($lines.Count -gt $MaxLines) {
        $oversized += [pscustomobject]@{ File = $f.FullName; Lines = $lines.Count }
    }

    foreach ($m in [regex]::Matches(($lines -join "`n"), $partialDeclRegex)) {
        $key = '{0} {1}' -f $m.Groups[1].Value, $m.Groups[2].Value
        if (-not $partials.ContainsKey($key)) {
            $partials[$key] = [System.Collections.Generic.HashSet[string]]::new()
        }
        [void]$partials[$key].Add($f.FullName)
    }
}

$violations = 0

# Rule 1 — a type's hand-written code spread across more than one file.
foreach ($kv in $partials.GetEnumerator()) {
    if ($kv.Value.Count -gt 1) {
        $violations++
        Write-Host "BANNED partial split: '$($kv.Key)' is hand-written across $($kv.Value.Count) files:" -ForegroundColor Red
        foreach ($file in ($kv.Value | Sort-Object)) { Write-Host "    $file" }
        Write-Host "    why: it is still ONE merged type -- extract a collaborator (pure-C# system), not a second partial half." -ForegroundColor DarkGray
    }
}

# Rule 2 — oversized files.
foreach ($o in ($oversized | Sort-Object Lines -Descending)) {
    $violations++
    Write-Host "OVERSIZED: $($o.File) has $($o.Lines) lines (> $MaxLines). Decompose by domain." -ForegroundColor Red
}

Write-Host ''
if ($violations -gt 0) {
    Write-Host "$violations decomposition violation(s). See the godot-csharp-clean-code skill." -ForegroundColor Red
    exit 1
}

Write-Host "Decomposition check passed: one file per type, no file over $MaxLines lines." -ForegroundColor Green
exit 0
