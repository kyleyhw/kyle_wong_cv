# Kyle Wong CV

A professional Curriculum Vitae authored in LaTeX, featuring dual-version output (Industry and Academic) managed via a single source file and a custom PowerShell build script.

## Directory Structure
```
kyle_wong_cv/
├── .gitignore
├── build_cv.ps1          # Custom build script (PowerShell, Windows)
├── build_cv.sh           # Custom build script (Bash, macOS/Linux)
├── main.tex              # Single-source LaTeX shell: preamble, \input{}s of sections, document body
├── industry.tex          # Thin wrapper: sets \isacademic=0, \input{main.tex}
├── academic.tex          # Thin wrapper: sets \isacademic=1, \input{main.tex}
├── sections/             # Per-section LaTeX files, one \newcommand{\sectionX}{...} each
│   ├── education.tex
│   ├── research.tex
│   ├── honours.tex
│   ├── skills.tex
│   ├── presentations.tex
│   ├── repos.tex
│   ├── courses.tex
│   ├── research_interests.tex
│   ├── relevant_experience.tex
│   ├── languages.tex
│   ├── memberships.tex
│   ├── personal_interests.tex
│   └── citizenships.tex
├── kyle_wong_cv_*.pdf    # Compiled PDF outputs (tracked in Git)
├── README.md             # This file
├── docs/                 # Documentation hub
└── references.bib        # BibTeX bibliography (currently unused)
```

## How to Build

The build process is automated via `build_cv.ps1`. You must specify a mandatory flag to choose the version:

### Industry Version
```powershell
.\build_cv.ps1 -industry
```
*Tailored for data science, software engineering, and quantitative research roles.*

### Academic Version
```powershell
.\build_cv.ps1 -academic
```
*Tailored for research fellowships and postgraduate applications, featuring more technical/academic descriptions.*

## Version Control Strategy
This repository uses **LaTeX conditional compilation** (`etoolbox` package) to maintain both versions from a single source. The toggle macros `\academicversion{...}` and `\industryversion{...}` wrap content that should appear in only one version; everything else is shared. This ensures that core information (Education, Skills, Contact Info) is always synchronized across both versions.

The source is split for editability:

- `main.tex` holds the preamble, the toggle definitions, the document body, and the conditional section-ordering block.
- `sections/*.tex` each define a single `\newcommand{\sectionX}{...}` for one CV section. `main.tex` pulls them in via `\input{}` before `\begin{document}`.
- `industry.tex` and `academic.tex` are 2-line wrappers that set `\isacademic` and `\input{main.tex}`. They are the files passed to `pdflatex` (via the build scripts).

Editing one section means opening one short file under `sections/` — no need to scroll through the full document.

The `main` branch is the primary branch for both development and Overleaf synchronization.

A previous multi-branch strategy (e.g., `quant-cv-updates`) was retired in favour of this single-source workflow to prevent version desynchronization; Git branches do not automatically inherit changes from one another, so long-lived parallel branches drift unless every shared edit is manually propagated.
