# build_cv.ps1
# This script builds the CV using pdflatex and renames it to the requested format.
# Requires a mandatory flag: -industry or -academic

param(
    [switch]$industry,
    [switch]$academic
)

if (-not $industry -and -not $academic) {
    Write-Error "Mandatory flag missing. Please use -industry or -academic."
    exit 1
}

if ($industry -and $academic) {
    Write-Error "Please specify only one flag: -industry or -academic."
    exit 1
}

$version = if ($industry) { "industry" } else { "academic" }
$latexToggle = if ($academic) { "\def\isacademic{1}" } else { "\def\isacademic{0}" }

$monthNames = @{
    1 = "jan"; 2 = "feb"; 3 = "mar"; 4 = "apr"; 5 = "may"; 6 = "jun"
    7 = "jul"; 8 = "aug"; 9 = "sep"; 10 = "oct"; 11 = "nov"; 12 = "dec"
}

$currentDate = Get-Date
$month = $monthNames[$currentDate.Month]
$year = $currentDate.Year

# Get current branch name
$branch = (git branch --show-current).Trim()
$targetFileName = "kyle_wong_cv_$($month)_$($year)_$($version).pdf"

# Clear old PDFs with the SAME version from the project root
Write-Host "Cleaning up old $version PDFs..."
Get-ChildItem -Filter "kyle_wong_cv_*_$($version).pdf" | Remove-Item -Force

Write-Host "Building $version CV..."
# Passing the toggle to pdflatex
pdflatex -interaction=nonstopmode -jobname=temp_build "$($latexToggle)\input{main.tex}"

if ($LASTEXITCODE -eq 0) {
    if (Test-Path "temp_build.pdf") {
        Move-Item -Path "temp_build.pdf" -Destination $targetFileName -Force
        Write-Host "Successfully built and renamed to $targetFileName"
        
        # Cleanup auxiliary files
        $extensions = @("*.aux", "*.log", "*.out", "*.toc", "*.blg", "*.bbl", "temp_build.*")
        foreach ($ext in $extensions) {
            Remove-Item $ext -ErrorAction SilentlyContinue
        }
        Write-Host "Cleanup complete."
    } else {
        Write-Error "PDF was not generated."
    }
} else {
    Write-Error "pdflatex failed. Check the logs."
}
