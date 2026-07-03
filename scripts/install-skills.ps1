param(
    [string]$Skill = "",
    [string]$CodexHome = ""
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot "skills"

if (-not (Test-Path -LiteralPath $sourceRoot)) {
    throw "Missing skills directory: $sourceRoot"
}

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    } else {
        $CodexHome = Join-Path $HOME ".codex"
    }
}

$targetRoot = Join-Path $CodexHome "skills"
New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if ([string]::IsNullOrWhiteSpace($Skill)) {
    $skillDirs = @(Get-ChildItem -LiteralPath $sourceRoot -Directory)
} else {
    $skillPath = Join-Path $sourceRoot $Skill
    if (-not (Test-Path -LiteralPath $skillPath)) {
        throw "Skill not found: $Skill"
    }
    $skillDirs = @(Get-Item -LiteralPath $skillPath)
}

foreach ($skillDir in $skillDirs) {
    $skillFile = Join-Path $skillDir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillFile)) {
        Write-Warning "Skipping $($skillDir.Name): missing SKILL.md"
        continue
    }

    $target = Join-Path $targetRoot $skillDir.Name
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Get-ChildItem -LiteralPath $skillDir.FullName -Force |
        ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse -Force
        }
    Write-Output "Installed $($skillDir.Name) -> $target"
}

Write-Output "Done. Start a new Codex session to use installed skills."
