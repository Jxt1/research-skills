param(
    [Parameter(Mandatory=$true)]
    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

function Normalize-Key {
    param([string]$Value)
    if ($null -eq $Value) { return "" }
    return (($Value.ToLowerInvariant() -replace "[^a-z0-9]+", " ").Trim() -replace "\s+", " ")
}

function Split-MarkdownRow {
    param([string]$Line)
    $trimmed = $Line.Trim()
    if ($trimmed.StartsWith("|")) {
        $trimmed = $trimmed.Substring(1)
    }
    if ($trimmed.EndsWith("|")) {
        $trimmed = $trimmed.Substring(0, $trimmed.Length - 1)
    }
    return @($trimmed -split "\s*\|\s*")
}

$refsDir = Join-Path $RepoRoot "doc\refs"
$indexPath = Join-Path $refsDir "index.md"
$problems = New-Object System.Collections.Generic.List[string]

if (-not (Test-Path -LiteralPath $indexPath)) {
    Write-Output "OK: index does not exist yet; it can be created on first add."
    exit 0
}

$lines = @(Get-Content -LiteralPath $indexPath)
if (-not ($lines | Where-Object { $_.Trim() -eq "# References" })) {
    $problems.Add("Missing '# References' title.")
}

$headerLineIndex = -1
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq "| Title | Year | Venue | DOI | PDF | Notes |") {
        $headerLineIndex = $i
        break
    }
}

if ($headerLineIndex -lt 0) {
    $problems.Add("Missing required table header: | Title | Year | Venue | DOI | PDF | Notes |")
} else {
    if ($headerLineIndex + 1 -ge $lines.Count -or $lines[$headerLineIndex + 1].Trim() -ne "| --- | --- | --- | --- | --- | --- |") {
        $problems.Add("Missing required Markdown separator row after the table header.")
    }
}

$seenTitles = @{}
$seenDois = @{}

if ($headerLineIndex -ge 0) {
    for ($i = $headerLineIndex + 2; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        if (-not $line.StartsWith("|")) {
            $problems.Add("Line $($i + 1) is not a Markdown table row.")
            continue
        }

        $cells = @(Split-MarkdownRow $line)
        if ($cells.Count -ne 6) {
            $problems.Add("Line $($i + 1) has $($cells.Count) cells; expected 6.")
            continue
        }

        $title = $cells[0].Trim()
        $doiCell = $cells[3].Trim()
        $pdfCell = $cells[4].Trim()

        if ([string]::IsNullOrWhiteSpace($title)) {
            $problems.Add("Line $($i + 1) has an empty title.")
        } else {
            $titleKey = Normalize-Key $title
            if ($seenTitles.ContainsKey($titleKey)) {
                $problems.Add("Line $($i + 1) duplicates title from line $($seenTitles[$titleKey]).")
            } else {
                $seenTitles[$titleKey] = $i + 1
            }
        }

        if ([string]::IsNullOrWhiteSpace($doiCell)) {
            $problems.Add("Line $($i + 1) has an empty DOI.")
        } elseif ($doiCell -match '^\[([^\]]+)\]\(https://doi\.org/([^)]+)\)$') {
            $doiText = $Matches[1].Trim().ToLowerInvariant()
            $doiUrl = $Matches[2].Trim().ToLowerInvariant()
            if ($doiText -ne $doiUrl) {
                $problems.Add("Line $($i + 1) DOI link text does not match its doi.org URL.")
            }
            if ($seenDois.ContainsKey($doiText)) {
                $problems.Add("Line $($i + 1) duplicates DOI from line $($seenDois[$doiText]).")
            } else {
                $seenDois[$doiText] = $i + 1
            }
        } else {
            $problems.Add("Line $($i + 1) DOI is not a Markdown link to https://doi.org/<doi>.")
        }

        if ($pdfCell -eq "missing-pdf") {
            continue
        } elseif ($pdfCell -match '^\[([^\]]+)\]\(([^)]+)\)$') {
            $pdfPath = $Matches[2].Trim()
            if ($pdfPath -match '^[a-z]+://') {
                $problems.Add("Line $($i + 1) PDF should be a local file link or missing-pdf, not a remote URL.")
            } else {
                $resolvedPdf = Join-Path $refsDir $pdfPath
                if (-not (Test-Path -LiteralPath $resolvedPdf)) {
                    $problems.Add("Line $($i + 1) PDF file does not exist: $pdfPath")
                }
            }
        } else {
            $problems.Add("Line $($i + 1) PDF cell must be a local Markdown link or missing-pdf.")
        }
    }
}

if ($problems.Count -gt 0) {
    Write-Output "PROBLEMS: doc/refs/index.md should be repaired before literature search."
    foreach ($problem in $problems) {
        Write-Output "- $problem"
    }
    exit 2
}

Write-Output "OK: doc/refs/index.md passed preflight checks."
exit 0
