# Kyle Wong CV

A professional Curriculum Vitae authored in LaTeX, featuring dual-version output (Industry and Academic) managed via a single source file and a custom PowerShell build script.

## Directory Structure
```
kyle_wong_cv/
├── .gitignore
├── build_cv.ps1          # Custom build script (PowerShell)
├── main.tex              # Single-source LaTeX file with Industry/Academic toggles
├── kyle_wong_cv_*.pdf    # Compiled PDF outputs (tracked in Git)
├── PROJECT_PLAN.md       # Development roadmap
├── README.md             # This file
├── docs/                 # Documentation hub
└── references.bib        # BibTeX bibliography
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
This repository uses **LaTeX conditional compilation** (`etoolbox` package) to maintain both versions in a single `main.tex` file. This ensures that core information (Education, Skills, Contact Info) is always synchronized across all versions.

The `master` branch is the primary branch for both development and Overleaf synchronization.

The previous multi-branch strategy (e.g., `quant-cv-updates`) has been retired and consolidated into this single-source workflow to prevent version desynchronization.
