param(
    [Parameter(Mandatory=$true)]
    [string]$RepoRoot,

    [Parameter(Mandatory=$true)]
    [string]$Title,

    [string]$Year = "",
    [string]$Venue = "",

    [Parameter(Mandatory=$true)]
    [string]$Doi,

    [string]$PdfFile = "",
    [string]$Notes = ""
)

$ErrorActionPreference = "Stop"

function Escape-MarkdownCell {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return ($Value -replace "\|", "\|" -replace "`r?`n", " ").Trim()
}

function Normalize-Key {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return (($Value.ToLowerInvariant() -replace "[^a-z0-9]+", " ").Trim() -replace "\s+", " ")
}

$refsDir = Join-Path $RepoRoot "doc\refs"
$indexPath = Join-Path $refsDir "index.md"
New-Item -ItemType Directory -Force -Path $refsDir | Out-Null

if (-not (Test-Path -LiteralPath $indexPath)) {
    @(
        "# References",
        "",
        "This index lists DOI-verified papers collected for this repository.",
        "",
        "| Title | Year | Venue | DOI | PDF | Notes |",
        "| --- | --- | --- | --- | --- | --- |"
    ) | Set-Content -LiteralPath $indexPath -Encoding UTF8
}

$doiTrimmed = $Doi.Trim()
$doiUrl = "https://doi.org/$doiTrimmed"
$pdfCell = "missing-pdf"
if (-not [string]::IsNullOrWhiteSpace($PdfFile)) {
    $pdfCell = "[$(Escape-MarkdownCell $PdfFile)]($PdfFile)"
}

$row = "| $(Escape-MarkdownCell $Title) | $(Escape-MarkdownCell $Year) | $(Escape-MarkdownCell $Venue) | [$doiTrimmed]($doiUrl) | $pdfCell | $(Escape-MarkdownCell $Notes) |"

$lines = Get-Content -LiteralPath $indexPath
$titleKey = Normalize-Key $Title
$doiKey = $doiTrimmed.ToLowerInvariant()
$updated = $false

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if (-not $line.StartsWith("|")) { continue }
    $lineKey = Normalize-Key $line
    if ($line.ToLowerInvariant().Contains($doiKey) -or ($titleKey -ne "" -and $lineKey.Contains($titleKey))) {
        $lines[$i] = $row
        $updated = $true
        break
    }
}

if ($updated) {
    $lines | Set-Content -LiteralPath $indexPath -Encoding UTF8
    Write-Output "updated $indexPath"
} else {
    Add-Content -LiteralPath $indexPath -Encoding UTF8 -Value $row
    Write-Output "added $indexPath"
}
