# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A LaTeX CV repository producing multiple variants (academic, industry, role-specific) via a **Git-branch-based architecture**. The currently-checked-out branch determines which variant the build script produces; there is no toggle-macro mechanism.

## Architecture

| Tier | Branch(es) | What lives there | Builds a CV? |
|---|---|---|---|
| 1 | `main` | Shared content only — the LaTeX shell, build/helper scripts, and the 9 section files identical across every variant (Honours, Presentations, Courses, Research Interests, Relevant Experience, Languages, Memberships, Personal Interests, Citizenships). The 4 variant-specific section files plus 2 include files exist as **empty stubs**. | Header only |
| 2 | `academic`, `industry` | Long-lived base templates. Each overrides the stubs with full variant-specific content (`education.tex`, `research.tex`, `repos.tex`, `skills.tex`, `section_order.tex`, plus `header_summary.tex` on academic only). | Yes |
| 3 | `<template>-<role>` (e.g. `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`) | Role variants forked off a tier-2 template. Hyphen-prefixed, NOT slash-prefixed — see Naming below. | Yes |

`main.tex` is a shell that `\input{}`s every file in `sections/` plus `sections/section_order.tex` (the literal `\sectionX` invocation list per variant) and `sections/header_summary.tex` (the optional academic summary paragraph). Both stubs are empty on `main`; variant branches populate them.

**Critical: the branch IS the variant.** Don't reintroduce toggle macros (`\academicversion`, `\industryversion`, `\isacademic`) or wrapper files (`industry.tex`, `academic.tex`). They were deliberately retired in commit `00f20bb`. The toggle-vs-branch trade-off is laid out in README §Version Control Strategy — read it before proposing to revert the architecture.

## Commands

Build (branch-driven, no flags):

```powershell
.\build_cv.ps1      # Windows (PowerShell)
./build_cv.sh       # macOS / Linux (Bash)
```

Output: `kyle_wong_cv_<month>_<year>_<branch>.pdf` (slashes in branch names become hyphens in the filename).

Archive a finished variant branch (creates `archive/<branch>-YYYY-MM-DD` tag, pushes it, deletes local + remote branch):

```powershell
.\archive_branch.ps1 <branch-name>      # e.g. industry-quant
./archive_branch.sh   <branch-name>
```

Sync shared edits from `main` outward:

```bash
git checkout academic && git rebase main && git push --force-with-lease
git checkout industry && git rebase main && git push --force-with-lease
# then each live role variant:
git checkout industry-quant && git rebase industry && git push --force-with-lease
```

**Rebase will conflict on `sections/research.tex`** (and any other variant-specific section file the variant has overridden) because main's stub disagrees with the variant's full content. Always resolve by keeping the variant's version:

```bash
git checkout --theirs sections/research.tex && git add sections/research.tex && git rebase --continue
```

(During a rebase, `--theirs` is the commit being applied — i.e. the variant branch's content. `--ours` would be main's stub, which is wrong on a variant branch.)

## PDF identity is a hard project constraint

Any structural change must preserve byte-identical PDF output for the existing template variants. Baselines:

- `industry`: 144074 bytes, 2 pages
- `academic`: 154563 bytes, 3 pages

Verify after any non-trivial edit:

```powershell
pdftotext -layout <pdf> <txt>
Compare-Object (Get-Content baseline.txt) (Get-Content new.txt)   # must be empty
pdfinfo <pdf> | Select-String "Pages:"                            # must match baseline
```

PDF SHA-256 hashes will differ from baselines because pdflatex embeds non-deterministic `/ID` and `/CreationDate` metadata — that is expected, not a regression. Identical file size + identical `pdftotext -layout` output + identical page count is the bar.

When editing or extracting section files, preserve byte-for-byte:
- Every trailing `%` at end of line (suppresses the newline — load-bearing for layout; especially `sections/courses.tex` lines 1–2 which use `%` to control `\vspace{-1em}` interaction).
- Blank lines inside `\newcommand{...}` bodies (they become `\par` tokens and produce inter-entry vertical spacing).
- Indentation inside `itemize` environments.

## Naming conventions

- **Variant branches**: `<template>-<role>` with hyphen, e.g. `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`. **Not slash** — slash would clash with the flat template names (`industry`, `academic`) in Git's ref storage: a branch named `industry` cannot coexist with a branch namespace `industry/...` because Git stores refs as files (`refs/heads/industry` can't be both a file and a directory).
- **Archive tags**: `archive/<branch>-YYYY-MM-DD`. The date suffix lets you archive the same role name multiple times (e.g. re-applying to the same firm later).

## CI

`.github/workflows/build_cv.yml` lives on each variant branch (not on `main`, since `main` doesn't build a complete CV). The workflow's `name:` field reflects the branch (e.g. `Build CV (industry-quant)`); update this field manually when creating a new variant branch.

## Prerequisites

`pdflatex` from MiKTeX (Windows, tested 24.1) or TeX Live / MacTeX (macOS/Linux). MiKTeX prompts to install missing packages on first compile. `pdftotext` and `pdfinfo` from Poppler (bundled with MiKTeX; `brew install poppler` on macOS; `apt install poppler-utils` on Linux) are needed for PDF identity verification.
