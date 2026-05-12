# build_cv.ps1
# Builds the CV from the current Git branch using pdflatex and names the
# output by month, year, and branch. The branch determines the CV variant.

$ErrorActionPreference = "Continue"

$branch = (git branch --show-current).Trim()
if (-not $branch) {
    Write-Error "Could not determine the current Git branch. Are you in a Git working tree?"
    exit 1
}

# Branch names may contain '/' (e.g. on legacy branches); normalise for use in a filename.
$branchFile = $branch -replace '/', '-'

$monthNames = @{
    1 = "jan"; 2 = "feb"; 3 = "mar"; 4 = "apr"; 5 = "may"; 6 = "jun"
    7 = "jul"; 8 = "aug"; 9 = "sep"; 10 = "oct"; 11 = "nov"; 12 = "dec"
}
$now = Get-Date
$month = $monthNames[$now.Month]
$year = $now.Year
$targetFileName = "kyle_wong_cv_$($month)_$($year)_$($branchFile).pdf"

Write-Host "Building CV from branch '$branch'..."

# Remove any previously-built PDF for this branch (same-name supersedes)
Get-ChildItem -Filter "kyle_wong_cv_*_$($branchFile).pdf" | Remove-Item -Force

pdflatex -interaction=nonstopmode -jobname=temp_build "\input{main.tex}"

if ($LASTEXITCODE -eq 0 -and (Test-Path "temp_build.pdf")) {
    Move-Item -Path "temp_build.pdf" -Destination $targetFileName -Force
    Write-Host "Successfully built $targetFileName"

    $extensions = @("*.aux", "*.log", "*.out", "*.toc", "*.blg", "*.bbl", "temp_build.*")
    foreach ($ext in $extensions) {
        Remove-Item $ext -ErrorAction SilentlyContinue
    }
    Write-Host "Cleanup complete."
} else {
    Write-Error "pdflatex failed. Check the logs."
    exit 1
}
