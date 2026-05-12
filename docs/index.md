# Kyle Wong CV: Documentation Hub

This repository contains the LaTeX source and compiled PDFs for my curriculum vitae. It produces dual-version output (Industry and Academic) from a single modular source, with builds automated via GitHub Actions on push to `main`.

For build instructions, editing guidance, and the full directory layout, see the [main README](../README.md).

## Compiled PDFs

The latest compiled PDFs live in the repo root, named `kyle_wong_cv_<month>_<year>_<version>.pdf`. Filenames are dated by build month and replaced in place each rebuild:

- **Industry CV**: `kyle_wong_cv_<month>_<year>_industry.pdf` — tailored for data science, software engineering, and quantitative research roles.
- **Academic CV**: `kyle_wong_cv_<month>_<year>_academic.pdf` — tailored for research fellowships and postgraduate applications.

## Automation

`.github/workflows/build_cv.yml` rebuilds both PDFs via [`xu-cheng/latex-action`](https://github.com/xu-cheng/latex-action) on every push to `main` that touches `main.tex`, the wrapper files, `references.bib`, or anything under `sections/**`.

## Version Control Strategy

This project uses a **single-source** workflow:

- **Source split**: `main.tex` provides the preamble, toggle macros, document body, and conditional section-ordering block. Each CV section lives in its own file under `sections/`, pulled in via `\input{}`. The wrapper files `industry.tex` and `academic.tex` set the `\isacademic` toggle and load `main.tex`.
- **Conditional compilation**: `etoolbox` `\ifbool` powers two macros, `\academicversion{...}` and `\industryversion{...}`, which mark content that should appear in only one version. Shared content is written once.
- **Branching**: `main` is the primary branch for development and Overleaf synchronization. A prior multi-branch strategy was retired because Git branches do not inherit changes from one another, so long-lived parallel branches drift unless every shared edit is manually propagated.

For one-shot tailored variants per job application (e.g., emphasising different bullets for a specific quant firm or research role), the repo uses short-lived `role/<name>` branches off `main`, archived as `archive/role-<name>-YYYY-MM-DD` tags after submission. The persistent academic-vs-industry split remains on `main` via toggles; only transient per-application tailoring uses branches, because their bounded lifetime bounds the drift cost. See the [README §Role-Specific Variants](../README.md#role-specific-variants) section for the full workflow and the `archive_role.ps1` / `archive_role.sh` helper scripts.

## Directory Structure

```
kyle_wong_cv/
├── .github/workflows/    # GitHub Actions automation
├── .gitignore
├── build_cv.ps1          # Build script (PowerShell, Windows)
├── build_cv.sh           # Build script (Bash, macOS/Linux)
├── archive_role.ps1      # Helper: archive a role/<name> branch (PowerShell)
├── archive_role.sh       # Helper: archive a role/<name> branch (Bash)
├── main.tex              # LaTeX shell: preamble + \input{}s + body
├── industry.tex          # Build entry: \def\isacademic{0}\input{main.tex}
├── academic.tex          # Build entry: \def\isacademic{1}\input{main.tex}
├── sections/             # 13 per-section files; one \newcommand{\sectionX}{...} each
├── kyle_wong_cv_*.pdf    # Compiled PDFs (tracked in Git)
├── README.md             # Project overview, build, and editing guide
├── docs/                 # This documentation hub
└── references.bib        # BibTeX bibliography (currently unused)
```
