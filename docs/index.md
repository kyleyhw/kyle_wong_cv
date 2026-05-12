# Kyle Wong CV: Documentation Hub

This repository contains the LaTeX source and compiled PDFs for my curriculum vitae. It produces multiple variants (industry, academic, and role-specific tailoring on top of those) via a Git-branch-based architecture, with the build determined by the currently-checked-out branch.

For build instructions, editing guidance, and the full directory layout, see the [main README](../README.md).

## Compiled PDFs

Compiled PDFs live on the **variant branches**, not on `main`. Each variant branch carries its own built PDF named `kyle_wong_cv_<month>_<year>_<branch>.pdf`.

- **Industry CV**: check out the `industry` branch — `kyle_wong_cv_<month>_<year>_industry.pdf` — tailored for data science, software engineering, and quantitative research roles.
- **Academic CV**: check out the `academic` branch — `kyle_wong_cv_<month>_<year>_academic.pdf` — tailored for research fellowships and postgraduate applications.
- **Role variants** (e.g., `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-...`): check out the relevant role branch and build; see [README §Role-Specific Variants](../README.md#role-specific-variants).

## Automation

CI lives on the variant branches (not on `main`, since `main` doesn't build a complete CV). `.github/workflows/build_cv.yml` on each variant triggers on push and rebuilds the PDF via [`xu-cheng/latex-action`](https://github.com/xu-cheng/latex-action), uploading the result as a workflow artifact.

## Version Control Strategy

The repo uses a **multi-branch architecture** for CV variants:

- **`main`**: shared content only. Holds the LaTeX shell (`main.tex`, build scripts, helper scripts) and section files for sections identical across every variant (Honours, Presentations, Courses, Research Interests, Relevant Experience, Languages, Memberships, Personal Interests, Citizenships). Variant-specific section files (Education, Research, Repos, Skills) and the variant-specific include files (`sections/header_summary.tex`, `sections/section_order.tex`) exist on `main` as **empty stubs**, so the LaTeX structure is complete but `main` itself builds only the header.
- **`academic`** and **`industry`**: long-lived **base templates**. Each overrides the stubs on `main` with full variant-specific content. The branch IS the variant-selection mechanism — no toggle macros, no wrapper files.
- **`<template>-<role>`** (e.g., `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`): **role variant branches** forked off the relevant template. The hyphen-prefixed naming encodes lineage — `git branch | grep '^  industry-'` lists all industry-derived variants. Can be long-lived (a template iterated across applications) or short-lived (one application, then archived).

**Note on naming.** Hyphen rather than slash is used to separate the template prefix from the role name, because Git's ref storage cannot simultaneously hold a branch named `industry` and a branch namespace `industry/...` — a directory at `refs/heads/industry/` can't coexist with a file at `refs/heads/industry`. Keeping the template names short (`academic`, `industry`) requires the hyphen prefix on role variants.

**Sync flow**: shared edit → `main` → `git rebase main` into `academic` and `industry` → `git rebase industry` (or `academic`) into any live `<template>-<role>` branches.

**Why branches?** Toggle macros scale linearly badly in source clutter with N variants; branches scale linearly badly in sync ritual with shared-edit frequency. For a personal CV — where shared edits are infrequent (an address change, a new course) and variant-specific edits are frequent (tailoring per application) — branches win on total cost. An earlier toggle-based iteration (`etoolbox` macros, `\isacademic` boolean, wrapper files) has been retired; that approach lives in git history if you want to reference it.

For the full workflow including reviving archives, syncing, and the `archive_branch.ps1` / `archive_branch.sh` helper scripts, see the [README §Role-Specific Variants](../README.md#role-specific-variants) section.

## Directory Structure

```
kyle_wong_cv/
├── .github/workflows/    # (variant branches only) CI build of the CV PDF
├── .gitignore
├── archive_branch.ps1    # Helper: archive any variant branch as a dated tag (PowerShell)
├── archive_branch.sh     # Helper: archive any variant branch as a dated tag (Bash)
├── build_cv.ps1          # Build script (PowerShell, Windows) — builds the current branch's variant
├── build_cv.sh           # Build script (Bash, macOS/Linux)
├── main.tex              # LaTeX shell: preamble + \input{}s + body
├── sections/             # One file per CV section (some shared, some variant-specific)
├── kyle_wong_cv_*.pdf    # (variant branches only) compiled PDF
├── README.md             # Project overview, build, and editing guide
├── docs/                 # This documentation hub
└── references.bib        # BibTeX bibliography (currently unused)
```
