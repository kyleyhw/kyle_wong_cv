# Project Development Plan: CV Consolidation and Git Cleanup

This document outlines the plan to consolidate multiple CV versions into a single-source LaTeX file and clean up the repository structure while maintaining Git-tracked PDFs for online visibility.

## Phase 1: Consolidation and Documentation
1.  [completed] Rename the primary branch to `master`.
2.  [completed] Implement `etoolbox` toggles in `main.tex` to support "Industry" (default) and "Academic" versions.
3.  [completed] Port improved descriptions and projects from the `quant-cv-updates` branch into the "Industry" logic in `main.tex`.
4.  [completed] Port the `README.md` from `quant-cv-updates` and modernize it with a directory diagram.
5.  [completed] Create a `docs/` folder with a documentation hub as per standard requirements.

## Phase 2: Build Automation and PDF Management
6.  [completed] Update `build_cv.ps1` to require a mandatory `-industry` or `-academic` flag (fails if no flag is provided).
7.  [completed] Configure the build script to update the tracked PDFs in the project root (e.g., `kyle_wong_cv_mar_2026_industry.pdf` and `kyle_wong_cv_mar_2026_academic.pdf`).
    - *Note: Per user request, PDFs will remain tracked in Git.*

## Phase 3: Git Cleanup
8.  [in-progress] Remove redundant or legacy PDF files (e.g., `kyle_wong_cv_nov_2025.pdf`, `kyle_wong_cv_oct_2025.pdf`) after replacing them with current versions.
9.  [pending] Delete the `quant-cv-updates` branch once the `master` branch can generate both versions.
10. [pending] Standardize the directory structure.

## Verification
-   `.\build_cv.ps1 -industry` generates the "Industry" PDF.
-   `.\build_cv.ps1 -academic` generates the "Academic" PDF.
-   Both PDFs are correctly tracked and visible on GitHub.
