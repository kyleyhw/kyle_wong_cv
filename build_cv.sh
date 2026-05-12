#!/usr/bin/env bash
# build_cv.sh
# Builds the CV from the current Git branch using pdflatex and names the
# output by month, year, and branch. The branch determines the CV variant.

set -euo pipefail

cd "$(dirname "$0")"

branch=$(git branch --show-current)
if [ -z "$branch" ]; then
    echo "Could not determine the current Git branch. Are you in a Git working tree?" >&2
    exit 1
fi

# Branch names may contain '/' (e.g. on legacy branches); normalise for filename.
branch_file=$(echo "$branch" | tr '/' '-')

month=$(date +%b | tr '[:upper:]' '[:lower:]')
year=$(date +%Y)
target="kyle_wong_cv_${month}_${year}_${branch_file}.pdf"

echo "Building CV from branch '${branch}'..."
find . -maxdepth 1 -type f -name "kyle_wong_cv_*_${branch_file}.pdf" -delete

pdflatex -interaction=nonstopmode -halt-on-error -jobname=temp_build "\input{main.tex}"

if [ ! -f temp_build.pdf ]; then
    echo "pdflatex failed: PDF was not generated." >&2
    exit 1
fi

mv temp_build.pdf "${target}"
echo "Successfully built ${target}"

rm -f temp_build.aux temp_build.log temp_build.out temp_build.toc temp_build.blg temp_build.bbl temp_build.fls temp_build.fdb_latexmk
echo "Cleanup complete."
