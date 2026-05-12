# Kyle Wong CV

A professional Curriculum Vitae authored in LaTeX with dual-version output (Industry and Academic) from a single modular source. Shared content is written once; version-specific content is marked with `\academicversion{...}` and `\industryversion{...}` toggle macros and compiled into the appropriate PDF by a wrapper script.

## Directory Structure
```
kyle_wong_cv/
├── .github/workflows/    # GitHub Actions automation
├── .gitignore
├── build_cv.ps1          # Build script (PowerShell, Windows)
├── build_cv.sh           # Build script (Bash, macOS/Linux)
├── main.tex              # LaTeX shell: preamble, \input{}s of sections, document body
├── industry.tex          # Wrapper: sets \isacademic=0, \input{main.tex}
├── academic.tex          # Wrapper: sets \isacademic=1, \input{main.tex}
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

## Prerequisites

A LaTeX distribution providing `pdflatex`:

- **Windows**: [MiKTeX](https://miktex.org/) — tested with MiKTeX 24.1. MiKTeX prompts to install any missing packages on first compile.
- **macOS / Linux**: [TeX Live](https://tug.org/texlive/) or [MacTeX](https://tug.org/mactex/), with the standard `texlive-latex-recommended` and `texlive-latex-extra` collections.

Required LaTeX packages (all standard): `extarticle`, `geometry`, `titlesec`, `enumitem`, `xcolor`, `hyperref`, `tabularx`, `fancyhdr`, `datetime`, `multicol`, `etoolbox`, `lmodern`, `fmtcount`.

Optional, for verifying PDF output is unchanged after source edits: `pdftotext` and `pdfinfo` from the Poppler tools (bundled with MiKTeX; `brew install poppler` on macOS; `apt install poppler-utils` on Linux).

## How to Build

Each invocation produces one PDF named `kyle_wong_cv_<month>_<year>_<version>.pdf` in the repo root, automatically replacing the previous PDF for that version.

### Windows (PowerShell)

```powershell
.\build_cv.ps1 -industry
.\build_cv.ps1 -academic
```

### macOS / Linux (Bash)

```bash
./build_cv.sh --industry
./build_cv.sh --academic
```

Note: PowerShell uses a single dash (`-industry`); Bash uses two (`--industry`).

### What the build scripts do

Each script prepends `\def\isacademic{0|1}` to the input passed to `pdflatex`, which `main.tex` reads to select between `\academicversion{...}` and `\industryversion{...}` content. The script then renames the output PDF and cleans up `.aux`, `.log`, and similar intermediate files.

## How to Edit

The source is structured so that editing one section of the CV means opening one short file under `sections/`. The four common cases:

### 1. Edit shared content (appears in both PDFs)

Open the relevant section file under `sections/` and edit the line directly. Example: to add a new course, open `sections/courses.tex` and add a new `\item` line inside the existing `itemize` block — no toggle needed.

### 2. Edit version-specific content (appears in only one PDF)

Wrap the content in the appropriate toggle macro inside the section file:

- `\academicversion{...}` — content appears only in the academic PDF.
- `\industryversion{...}` — content appears only in the industry PDF.

Example: to add a bullet that only appears in the industry version of `Skills`, open `sections/skills.tex` and add:

```latex
\industryversion{\item \textbf{Foo:} Description of foo.}
```

### 3. Same underlying fact, different phrasing per version

Use both toggles back-to-back. The academic build renders the first; the industry build renders the second. Real example from `sections/research.tex`:

```latex
\academicversion{\item Research topic: implementation and statistical testing of variable initial conditions...}
\industryversion{\item Implemented and statistically validated variable cosmological initial conditions...}
```

### 4. Reorder sections (or include/exclude a section per version)

Section ordering lives in `main.tex` inside the `\ifbool{academic}{...}{...}` block in the document body. The first branch is the academic order; the second is the industry order. To move a section, change its position in the list; to exclude it from one version, remove its invocation from that branch.

```latex
\sectionEducation
\sectionResearch
\ifbool{academic}{
  \newpage
  \sectionHonours
  \sectionSkills
  ...
}{
  \sectionRepos
  \newpage
  ...
}
```

### Adding a new section

1. Create `sections/new_section.tex` with one `\newcommand{\sectionNewName}{...}` definition.
2. Add `\input{sections/new_section.tex}` to the `% Section Definitions` block in `main.tex` (after the preamble, before `\begin{document}`).
3. Invoke `\sectionNewName` in the appropriate branch(es) of the `\ifbool{academic}{...}{...}` ordering block.

### Editing the header (name, contact info, academic summary)

The header lives in `main.tex` inside the `\begin{flushleft}...\end{flushleft}` block, not in a section file. The academic-only summary paragraph is wrapped in `\academicversion{...}` there.

## Version Control Strategy

This repository uses **LaTeX conditional compilation** (`etoolbox` package) to maintain both versions from a single source. The toggle macros `\academicversion{...}` and `\industryversion{...}` wrap content that should appear in only one version; everything else is shared. This ensures that core information (Education, Skills, Contact Info) is always synchronized across both versions.

The source is split for editability:

- `main.tex` holds the preamble, the toggle definitions, the document body, and the conditional section-ordering block.
- `sections/*.tex` each define a single `\newcommand{\sectionX}{...}` for one CV section. `main.tex` pulls them in via `\input{}` before `\begin{document}`.
- `industry.tex` and `academic.tex` are 2-line wrappers that set `\isacademic` and `\input{main.tex}`. They are the files passed to `pdflatex` (via the build scripts).

Editing one section means opening one short file under `sections/` — no need to scroll through the full document.

The `main` branch is the primary branch for both development and Overleaf synchronization.

A previous multi-branch strategy (e.g., `quant-cv-updates`) was retired in favour of this single-source workflow to prevent version desynchronization; Git branches do not automatically inherit changes from one another, so long-lived parallel branches drift unless every shared edit is manually propagated.

## Documentation

- [Documentation Hub](docs/index.md) — repository overview and CI/automation details.
