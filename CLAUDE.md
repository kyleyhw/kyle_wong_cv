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

- `industry`: 139072 bytes, 2 pages
- `academic`: 148177 bytes, 3 pages

(Measured 2026-09-20 against TeX Live 2023 and reproduced byte-for-byte from a
clean checkout, after both branches were migrated onto the vertical rhythm
below. The figures immediately before that migration were 138996 / 148195, and
the 144074 / 154563 documented earlier predate later content edits. `industry`
moved from 138960 to 139015 on 2026-09-26 when the `agent_evolve` repo label
was corrected to `agent-evolve`, a content edit, and then to 139072 the same day
when that label's bold hyphen was widened with `\scalebox` -- a glyph change
only, with `pdftotext -layout` output unchanged. Both variants were then
standardised on British spelling (visualisation, dockerised): `industry` kept
its size, and `academic` moved from 148178 to 148177.)

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

Blank lines inside `\newcommand{...}` bodies are no longer load-bearing: under
`\setlist{nosep}` their `\par` produces no space. Entry separation now comes
from `\cventrygap` alone. Do not reintroduce blank lines or bare `\vspace` to
create space — see below.

## Vertical spacing is rule-driven

All vertical space is declared in `main.tex` under "Vertical rhythm" and is
explicit and rigid, so gaps never vary with list membership or with how full a
page is. The levels, all measured against `\baselineskip` (11.955pt at 10pt):

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
half-empty page. The values above put it back. Check page fill after retuning,
not just the gaps.

To retune spacing, edit the four lengths in `main.tex`. Never add a bare
`\vspace`, a trailing `\\`, or blank lines to a section file to create space —
that is how the pre-rule CV ended up with three different entry gaps (18.16 /
23.14 / 23.91pt) for the same level of hierarchy.

Multi-column sections use `\begin{cvcolumns}{2}`, not `multicols` directly. It
sets `\topskip` to `\ht\strutbox` for the columns, replacing the old
`\vspace{-1em}` hack in `sections/courses.tex`. Default `\topskip` (10pt) put
SELECTED COURSES ~3pt below the rhythm; setting it to `0pt` fixes that but
lets each column's first baseline follow its own first line's height, which
knocks the two columns ~0.6pt out of alignment with each other. A strut height
is at least as tall as any normal line, so both columns are forced onto the
same baseline. The cost is that SELECTED COURSES' heading gap runs ~1pt looser
(17.54pt) than other sections — cross-column alignment is worth more than that.

### Variants must be migrated before they rebase

The machinery lives on `main`, but it only *removes* the old implicit spacing;
it cannot know where a variant wants its gaps. A variant whose section files
still lean on list defaults and blank lines loses its entry separation the
moment it rebases — RESEARCH EXPERIENCE and FEATURED PERSONAL PROJECTS run
together into unbroken blocks, the collapse failure above. This was measured,
not assumed: test-rebasing unmigrated `industry` and `academic` kept their page
counts and their text and still produced that collapse.

**Migrated:** `industry-quant`, `industry`, `academic`.
**Not yet migrated:** `industry-quantum-consulting`, and any variant branched
from a pre-migration template. Migrate before rebasing it onto `main`.

Migration touches exactly three files — `sections/research.tex`,
`sections/repos.tex`, `sections/education.tex` — for twelve call sites in
total. They are the only sections holding multiple entries; single-list
sections (HONOURS, LANGUAGES, MEMBERSHIPS, PERSONAL INTERESTS, SKILLS,
PRESENTATIONS) have no inter-entry structure to lose, RELEVANT EXPERIENCE is a
nested list that correctly takes no gap, and SELECTED COURSES is handled on
`main` by `cvcolumns`. The three files are variant-specific, which is why they
cannot be fixed once on `main`.

The edit, per entry:

- `\cvlistgap` immediately before the entry's `\begin{itemize}`. Where a
  variant puts extra header lines before the list (academic's `Supervised
  by …`, joined on with a trailing `\\`), the gap goes after them: it belongs
  between the header block as a whole and its bullets.
- `\cventrygap` at each entry boundary, *replacing* what used to make that gap
  — the blank lines, any trailing `\\` left dangling at the end of an entry,
  and any ad-hoc `\vspace`. Leaving the old markers in alongside the macro
  double-counts the gap.

Then rebuild, confirm the page count holds and that `pdftotext -layout` output
is character-identical once whitespace is normalised (migration is layout-only
and must never move content), check the rendered pages for the ordering
invariant, and re-measure the branch's baseline above.

## Naming conventions

- **Variant branches**: `<template>-<role>` with hyphen, e.g. `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`. **Not slash** — slash would clash with the flat template names (`industry`, `academic`) in Git's ref storage: a branch named `industry` cannot coexist with a branch namespace `industry/...` because Git stores refs as files (`refs/heads/industry` can't be both a file and a directory).
- **Archive tags**: `archive/<branch>-YYYY-MM-DD`. The date suffix lets you archive the same role name multiple times (e.g. re-applying to the same firm later).

## CI

`.github/workflows/build_cv.yml` lives on each variant branch (not on `main`, since `main` doesn't build a complete CV). The workflow's `name:` field reflects the branch (e.g. `Build CV (industry-quant)`); update this field manually when creating a new variant branch.

It holds two jobs. `build` produces a PDF artifact and is gated to
`workflow_dispatch`, so PDFs are still built locally with `build_cv.sh` and
committed by hand. `verify` runs on push and is described below.

### Page budget check

`verify` builds `main.tex` in the runner and reports two things: whether the CV
came out at its expected page count, and whether any page's body text overran
the text block. It is **advisory** — it emits `::warning::` annotations and a
job-summary section, and always exits 0. It never fails a run, produces no
artifact, and writes nothing to the repository; the committed PDF is not read
and not touched.

Expected page counts, set per branch by the `EXPECTED` constant in the job:

| Branch | Pages | Slack on its tightest page |
|---|---|---|
| `tutoring` | 1 | 10.0pt |
| `industry` | 2 | 1.0pt |
| `industry-quant` | 2 | 1.0pt |
| `academic` | 3 | 80.7pt |

**Why it measures the margin and not just the page count.** Content overruns
the text block before it forces an extra page, so a page-count assertion alone
passes a layout that is already broken. This is not hypothetical: a simulated
rebase that auto-merged one shared course into `tutoring`'s trimmed
`sections/courses.tex` produced a *one-page* PDF whose body ran 2.0pt into the
bottom margin, with no conflict, no overfull box, and the right page count.

**Why the page number is discounted.** `fancyhdr` sets the folio in the bottom
margin by design, 33.4pt below the text block, so on any multi-page CV the
lowest "text" on the page is the page number rather than body content. The
check drops a word below the text block that is exactly that page's number and
treats anything else down there as spilled body text. Without that, every
multi-page variant fails immediately and spuriously.

**When it fires.** Rebuild locally with `build_cv.sh` and compare before
acting. Two causes are likely. Either the layout genuinely changed, or a rebase
from `main` auto-merged shared content into a section file the variant
overrides — see *Shared-file overrides* below. A third possibility is neither:
page breaks depend on the TeX distribution, and the runner's need not match the
one the committed PDF was built with, which is why this check advises rather
than blocks.

**What it does not cover.** It rebuilds from source and never compares against
the committed PDF, so a stale committed PDF passes. It does not check content,
and it does not catch overfull *hboxes*.

### Shared-file overrides

A variant may override one of the nine tier-1 shared section files when the
shared version does not suit it — `tutoring` overrides
`sections/relevant_experience.tex` and `sections/courses.tex`. Rebasing such a
branch onto `main` behaves in one of two ways, and the difference matters:

- **Conflicts loudly** when the override replaces the whole file body, as
  `relevant_experience.tex` does. Resolve by keeping the variant's version
  (`git checkout --theirs` during a rebase onto `main`).
- **Auto-merges silently** when the override is a subset or light edit of
  `main`'s version, as `courses.tex` is — a trimmed list in the same order.
  Git merges upstream additions straight in, with no conflict to notice.

The second case is what the page budget check exists to catch. Any file
overridden this way should say so in a header comment, naming which behaviour
to expect.

## Prerequisites

`pdflatex` from MiKTeX (Windows, tested 24.1) or TeX Live / MacTeX (macOS/Linux). MiKTeX prompts to install missing packages on first compile. `pdftotext` and `pdfinfo` from Poppler (bundled with MiKTeX; `brew install poppler` on macOS; `apt install poppler-utils` on Linux) are needed for PDF identity verification.
