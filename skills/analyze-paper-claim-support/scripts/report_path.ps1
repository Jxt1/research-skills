param(
    [Parameter(Mandatory = $true)]
    [string] $CitationId,

    [string] $ShortTitle = "",

    [string] $RepoRoot = (Get-Location).Path,

    [switch] $CreateDirectory
)

function ConvertTo-Slug {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value,

        [int] $MaxLength = 80
    )

    $slug = $Value.ToLowerInvariant()
    $slug = [regex]::Replace($slug, '[^a-z0-9]+', '-')
    $slug = [regex]::Replace($slug, '-{2,}', '-').Trim('-')

    if ($slug.Length -gt $MaxLength) {
        $slug = $slug.Substring(0, $MaxLength).Trim('-')
    }

    if ([string]::IsNullOrWhiteSpace($slug)) {
        return "citation"
    }

    return $slug
}

$citationSlug = ConvertTo-Slug -Value $CitationId -MaxLength 80
$titleSlug = ""
if (-not [string]::IsNullOrWhiteSpace($ShortTitle)) {
    $titleSlug = ConvertTo-Slug -Value $ShortTitle -MaxLength 70
}

$fileName = if ($titleSlug) {
    "$citationSlug--$titleSlug.md"
} else {
    "$citationSlug.md"
}

$reportDir = Join-Path $RepoRoot "doc\reports"
if ($CreateDirectory -and -not (Test-Path -LiteralPath $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}

Join-Path $reportDir $fileName
