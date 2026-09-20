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

- `industry`: 138996 bytes, 2 pages
- `academic`: 148195 bytes, 3 pages

(Re-measured 2026-09-20 with TeX Live 2023. The previously documented 144074 /
154563 predate later content edits. `industry-quant` intentionally departs from
`industry` — see Vertical spacing below.)

Verify after any non-trivial edit:

```powershell
pdftotext -layout <pdf> <txt>
Compare-Object (Get-Content baseline.txt) (Get-Content new.txt)   # must be empty
pdfinfo <pdf> | Select-String "Pages:"                            # must match baseline
```

PDF SHA-256 hashes will differ from baselines because pdflatex embeds non-deterministic `/ID` and `/CreationDate` metadata — that is expected, not a regression. Identical file size + identical `pdftotext -layout` output + identical page count is the bar.

When editing or extracting section files, preserve byte-for-byte:
- Every trailing `%` at end of line (suppresses the newline — load-bearing for layout).
- Indentation inside `itemize` environments.

## Vertical spacing is rule-driven

**This currently applies to `industry-quant` only; it still needs to be lifted
to `main` and propagated to the other variants.**

All vertical space is declared in `main.tex` under "Vertical rhythm" and is
explicit and rigid, so gaps never vary with list membership or with how full a
page is. Three levels, all multiples of `\baselineskip` (11.955pt at 10pt):

| Level | Gap | Mechanism |
|---|---|---|
| line → line inside a paragraph | 1.00 line (11.96pt) | leading; not adjustable |
| bullet → bullet | 1.00 line (11.96pt) | `\setlist{nosep}` — lists add nothing |
| entry header → its own bullets | 1.25 lines (14.95pt) | `\cvlistgap` |
| section heading → its first content | ~1.35 lines (16.0–16.6pt) | `\cvHeadGap` |
| entry → entry | 1.67 lines (19.93pt) | `\cventrygap` |
| section → section | 2.17 lines (25.91pt) | `\cvSectionGap`, via `\titlespacing` |

Two failure modes, both of which this CV has actually had:

**Levels must not invert.** Anything inside an entry has to be closer than the
gap separating two entries, which has to be closer than the gap separating two
sections. The pre-rule CV set entry headers further from their own bullets
(18.15pt) than from the section heading above them (12.66pt), which made the
bullets look like they belonged to the section rather than to their header.

**Levels must not collapse.** Putting an entry's bullets, the bullet-to-bullet
gap and the section-heading gap all at 1.0 line is perfectly *consistent* and
reads as cramped, because nothing inside a section is articulated — a heading
ends up no better separated from its content than two wrapped lines of one
sentence. Keep the levels distinct and ordered, not merely equal.

Spacing also has to be spent, not just saved. Retiring `\topsep` reclaimed
~48pt on page 1; left unspent that made the CV denser *and* gave it a
half-empty page. The values above put it back, landing page 1 at 4.5pt of
slack (the pre-rule CV had 6.2pt). Check page fill after retuning, not just
the gaps.

To retune spacing, edit the three lengths in `main.tex`. Never add a bare
`\vspace`, a trailing `\\`, or blank lines to a section file to create space —
that is how the pre-rule CV ended up with three different entry gaps (18.16 /
23.14 / 23.91pt) for the same level of hierarchy.

Blank lines in section files are for readability only and produce no space:
after `\end{itemize}` TeX is already in vertical mode, so the extra `\par` is a
no-op, and `\setlist{nosep}` zeroes `parsep`, so blank lines between `\item`s
do nothing either.

Multi-column sections use `\begin{cvcolumns}{2}`, not `multicols` directly. It
sets `\topskip` to `\ht\strutbox` for the columns, replacing the old
`\vspace{-1em}` hack in `sections/courses.tex`. Default `\topskip` (10pt) put
SELECTED COURSES ~3pt below the rhythm; setting it to `0pt` fixes that but
lets each column's first baseline follow its own first line's height, which
knocks the two columns ~0.6pt out of alignment with each other. A strut height
is at least as tall as any normal line, so both columns are forced onto the
same baseline. The cost is that SELECTED COURSES' heading gap runs ~1pt looser
(17.54pt) than other sections — cross-column alignment is worth more than that.

Known residues, all sub-perceptual and content-driven rather than rule-driven:
heading → first content varies 12.04–12.66pt because it depends on the height
of the first line's tallest glyph; a line inside a wrapped bullet sits the same
1.0 line from its neighbour as two separate bullets do, so the bullet marker is
the only cue distinguishing them (a consequence of `nosep`, and deliberate).

## Naming conventions

- **Variant branches**: `<template>-<role>` with hyphen, e.g. `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`. **Not slash** — slash would clash with the flat template names (`industry`, `academic`) in Git's ref storage: a branch named `industry` cannot coexist with a branch namespace `industry/...` because Git stores refs as files (`refs/heads/industry` can't be both a file and a directory).
- **Archive tags**: `archive/<branch>-YYYY-MM-DD`. The date suffix lets you archive the same role name multiple times (e.g. re-applying to the same firm later).

## CI

`.github/workflows/build_cv.yml` lives on each variant branch (not on `main`, since `main` doesn't build a complete CV). The workflow's `name:` field reflects the branch (e.g. `Build CV (industry-quant)`); update this field manually when creating a new variant branch.

## Prerequisites

`pdflatex` from MiKTeX (Windows, tested 24.1) or TeX Live / MacTeX (macOS/Linux). MiKTeX prompts to install missing packages on first compile. `pdftotext` and `pdfinfo` from Poppler (bundled with MiKTeX; `brew install poppler` on macOS; `apt install poppler-utils` on Linux) are needed for PDF identity verification.
