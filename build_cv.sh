#!/usr/bin/env bash
# build_cv.sh
# Builds the CV using pdflatex and renames it to the requested format.
# Requires a mandatory flag: --industry or --academic
# macOS/Linux equivalent of build_cv.ps1

set -euo pipefail

usage() {
    echo "Usage: $0 (--industry|--academic)" >&2
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    --industry)
        version="industry"
        latex_toggle='\def\isacademic{0}'
        ;;
    --academic)
        version="academic"
        latex_toggle='\def\isacademic{1}'
        ;;
    *)
        usage
        ;;
esac

cd "$(dirname "$0")"

month=$(date +%b | tr '[:upper:]' '[:lower:]')
year=$(date +%Y)
target="kyle_wong_cv_${month}_${year}_${version}.pdf"

echo "Cleaning up old ${version} PDFs..."
find . -maxdepth 1 -type f -name "kyle_wong_cv_*_${version}.pdf" -delete

echo "Building ${version} CV..."
pdflatex -interaction=nonstopmode -halt-on-error -jobname=temp_build "${latex_toggle}\input{main.tex}"

if [ ! -f temp_build.pdf ]; then
    echo "pdflatex failed: PDF was not generated." >&2
    exit 1
fi

mv temp_build.pdf "${target}"
echo "Successfully built ${target}"

# Cleanup auxiliary files
rm -f temp_build.aux temp_build.log temp_build.out temp_build.toc temp_build.blg temp_build.bbl temp_build.fls temp_build.fdb_latexmk
echo "Cleanup complete."
