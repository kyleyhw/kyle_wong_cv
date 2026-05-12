# Kyle Wong CV

A professional Curriculum Vitae authored in LaTeX with multiple variants managed via Git branches. The `main` branch holds shared content only; the `academic` and `industry` branches are the base templates; further branches with hyphen-prefixed names (`industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`, etc.) carry role-specific tailoring built on top of the relevant template.

## Directory Structure

```
kyle_wong_cv/
├── .github/workflows/    # (template/role branches only) CI build of the CV PDF
├── .gitignore
├── archive_branch.ps1    # Helper: archive any variant branch as a dated tag (PowerShell)
├── archive_branch.sh     # Helper: archive any variant branch as a dated tag (Bash)
├── build_cv.ps1          # Build script (PowerShell, Windows) — builds the current branch's variant
├── build_cv.sh           # Build script (Bash, macOS/Linux)
├── main.tex              # LaTeX shell: preamble + \input{}s of section files + body
├── sections/             # One file per CV section
│   ├── citizenships.tex          # SHARED (defined on main; inherited unchanged on variant branches)
│   ├── courses.tex               # SHARED
│   ├── education.tex             # VARIANT — stub on main, overridden per variant branch
│   ├── header_summary.tex        # VARIANT — empty on main, populated on academic (summary paragraph)
│   ├── honours.tex               # SHARED
│   ├── languages.tex             # SHARED
│   ├── memberships.tex           # SHARED
│   ├── personal_interests.tex    # SHARED
│   ├── presentations.tex         # SHARED
│   ├── relevant_experience.tex   # SHARED
│   ├── repos.tex                 # VARIANT — stub on main, overridden per variant branch
│   ├── research.tex              # VARIANT — stub on main, overridden per variant branch
│   ├── research_interests.tex    # SHARED
│   ├── section_order.tex         # VARIANT — empty on main; each variant branch supplies its own \sectionX invocation list
│   └── skills.tex                # VARIANT — stub on main, overridden per variant branch
├── kyle_wong_cv_*.pdf    # (variant branches only) compiled PDF, named by month_year_branch
├── README.md             # This file
├── docs/                 # Documentation hub
└── references.bib        # BibTeX bibliography (currently unused)
```

`main` does not commit a built PDF; the variant branches each commit their own.

## Prerequisites

A LaTeX distribution providing `pdflatex`:

- **Windows**: [MiKTeX](https://miktex.org/) — tested with MiKTeX 24.1. MiKTeX prompts to install any missing packages on first compile.
- **macOS / Linux**: [TeX Live](https://tug.org/texlive/) or [MacTeX](https://tug.org/mactex/), with the standard `texlive-latex-recommended` and `texlive-latex-extra` collections.

Required LaTeX packages (all standard): `extarticle`, `geometry`, `titlesec`, `enumitem`, `xcolor`, `hyperref`, `tabularx`, `fancyhdr`, `datetime`, `multicol`, `lmodern`, `fmtcount`.

Optional, for verifying that PDF output is unchanged after source edits: `pdftotext` and `pdfinfo` from the Poppler tools (bundled with MiKTeX; `brew install poppler` on macOS; `apt install poppler-utils` on Linux).

## How to Build

The build is variant-driven by **which branch you currently have checked out**. The output PDF is named `kyle_wong_cv_<month>_<year>_<branch>.pdf`.

### Windows (PowerShell)

```powershell
git checkout academic              # or industry, industry-quant, academic-postdoc-..., etc.
.\build_cv.ps1
```

### macOS / Linux (Bash)

```bash
git checkout academic              # or industry, industry-quant, etc.
./build_cv.sh
```

`main` builds successfully but produces a near-empty PDF (just the header), because section content lives only on variant branches.

## How to Edit

The architecture defines what lives where:

- **`main`** holds the sections identical across every variant — Honours, Presentations, Courses, Research Interests, Relevant Experience, Languages, Memberships, Personal Interests, Citizenships — plus the LaTeX shell (`main.tex`, build scripts, helper scripts).
- **`academic`** and **`industry`** are long-lived **base templates**. Each carries its own full content for the variant-specific sections (Education, Research, Repos, Skills), its own `section_order.tex`, and (for academic only) the summary paragraph in `header_summary.tex`.
- **`industry-<role>`** and **`academic-<role>`** are **role variant branches** forked off the relevant template (`industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`, etc.). They can be long-lived (iterated across applications) or short-lived (one application, then archived). See [§Role-Specific Variants](#role-specific-variants).

### Editing shared content

Examples: updating contact info, adding a new course, fixing a typo in Memberships, adding a new language.

1. Check out `main`: `git checkout main`.
2. Edit the relevant `sections/*.tex` file (only shared sections — Honours, Courses, Languages, etc. — live on `main`).
3. Commit and push.
4. **Propagate to variant branches**:
   ```bash
   git checkout academic && git rebase main && git push --force-with-lease
   git checkout industry && git rebase main && git push --force-with-lease
   # then for each role variant:
   git checkout industry-quant && git rebase industry && git push --force-with-lease
   git checkout industry-quantum-consulting && git rebase industry && git push --force-with-lease
   # ... etc.
   ```

This is the manual-sync cost of the branch-based architecture. It is bounded by how often shared edits happen — typically rare for a CV (address changes, occasional new course or membership).

### Editing variant-specific content

Examples: rephrasing the Research bullets for industry framing, adding an industry-only Skills item, reordering sections for academic, emphasising quant projects on `industry-quant`.

1. Check out the relevant variant branch: `git checkout industry` (or `academic`, or `industry-quant`, etc.).
2. Edit the section file directly. The variant branch has its own version of the file with content directly written (no toggle macros — the branch IS the variant selector).
3. Build to verify: `.\build_cv.ps1` (or `./build_cv.sh`).
4. Commit and push.

Variant-specific edits do **not** propagate to other branches. Industry's Research wording stays on `industry`; academic's stays on `academic`; quant-specific tailoring stays on `industry-quant`.

### Reordering sections (per variant)

Each variant branch has its own `sections/section_order.tex` containing the literal list of `\sectionX` invocations in the desired order, with `\newpage` calls where needed. Edit this file on the relevant branch to change ordering.

Example (academic's `sections/section_order.tex`):

```latex
\sectionEducation
\sectionResearch
\newpage
\sectionHonours
\sectionSkills
...
```

### Adding a new section

1. On `main`: create `sections/new_section.tex` with `\newcommand{\sectionNewName}{}` (stub).
2. On `main`: add `\input{sections/new_section.tex}` to the `% Section Definitions` block in `main.tex`.
3. Commit, push, and rebase the variant branches.
4. On each variant branch that should include the section: override `sections/new_section.tex` with the populated `\newcommand{\sectionNewName}{...}`, and add `\sectionNewName` at the desired position in that branch's `sections/section_order.tex`. Build to verify.

## Version Control Strategy

This repository uses a **multi-branch architecture** for managing CV variants. Reading this section will tell you what's where, why this design was chosen over the alternative, and what trade-offs were accepted.

### The architecture

- **`main`**: shared content only. Holds the LaTeX shell (`main.tex`, build scripts, helper scripts) and the section files for sections identical across every variant. The variant-specific section files (`education`, `research`, `repos`, `skills`) and the include files (`header_summary`, `section_order`) exist as **empty stubs** — empty `\newcommand` definitions and comment-only include files — so the LaTeX structure is complete but `main` itself builds only the header.

- **`academic`** and **`industry`**: long-lived **base templates**, each overriding the stubs with its own variant-specific content. Building from either branch produces the corresponding CV. The branch IS the variant-selection mechanism — no toggle macros, no `\isacademic` boolean, no wrapper files.

- **`<template>-<role>`** (e.g., `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`): **role variant branches**, forked off the relevant template. The `<template>-` prefix encodes lineage so `git branch | grep '^  industry-'` lists all industry-derived variants. These can be long-lived (a quant template you iterate on across applications) or short-lived (one application, archived after submission). See [§Role-Specific Variants](#role-specific-variants).

> **Note on naming.** Git's ref storage means you cannot have both `industry` as a branch and `industry/<x>` as a branch namespace simultaneously — a directory at `refs/heads/industry/` can't coexist with a file at `refs/heads/industry`. To keep the template names short (`academic`, `industry`) and still encode lineage in role variants, the prefix is separated by a hyphen rather than a slash: `industry-quant` instead of `industry/quant`.

### Why branches, and not toggle macros?

An earlier iteration of this repository used `etoolbox` toggle macros — `\academicversion{X}` expanded to `X` when the academic boolean was set, otherwise to nothing; `\industryversion{X}` did the inverse. A single source tree on `main` carried both variants' content; thin wrapper files (`industry.tex`, `academic.tex`) set the toggle and built the corresponding PDF. That worked for N = 2 variants.

It does not scale. Each additional persistent variant — say a quant-fund template, or an ML-research template — would need its own toggle macro (`\quantversion{...}`, `\mlversion{...}`). Every version-specific piece of content would then carry **N adjacent wrappers**, e.g.

```latex
\academicversion{\item Investigated ...}\industryversion{\item Implemented ...}\quantversion{\item Built a high-frequency ...}\mlversion{\item Trained a transformer ...}
```

Section files clutter linearly with N. Editing one variant means visually filtering past the other N − 1 variants' phrasings of the same fact on adjacent lines. Adding a new variant means revisiting every version-conditional bullet across every section file and wrapping it again.

Branches sidestep that clutter entirely: each branch's section files contain *only* that branch's content, with no toggle macros. Reading or editing the academic version means looking at files that contain only academic prose; there is nothing else on the page to filter past.

### What's the trade-off?

Branches have a real cost: **manual sync on shared edits**. Any change that should appear in *every* variant — an address update, a new course, a typo fix in a shared bullet, a new club membership — must be made on `main` and then propagated into each variant branch by rebase. For N branches, that's O(N) git operations per shared edit.

The trade-off is favourable when:

- **Shared edits are infrequent.** For a CV: address changes happen rarely, new courses every few months, typo fixes occasionally. Maybe once a month total.
- **Variant-specific edits are frequent.** Every job application produces a new tailored variant.
- **N is open-ended.** New role variants will keep appearing over a job-search career.

Branches strictly win in that regime. The toggle-clutter cost dominates if you stay with toggles; the sync cost is bounded and predictable with branches.

**Decision matrix** for choosing between the two:

| Workload | Right tool |
|---|---|
| N = 2 persistent variants, frequent shared edits | Toggles |
| N ≥ 3 persistent variants, infrequent shared edits | Branches |
| Any number of short-lived per-application variants | Branches |
| Strict simultaneous parity across variants required (e.g., test suites enforcing it) | Toggles (CI-enforced) |

This repo's workload is the third row (plus a small dose of the second), so branches are the right choice. If the workload shifts — say, you stop tailoring per application and just maintain two CVs — reassess.

### Why three tiers? (main → templates → role variants)

The architecture is a two-level hierarchy rooted at `main`:

| Tier | Branch(es) | What lives there | Lifetime | Builds a CV? |
|---|---|---|---|---|
| 1 | `main` | Shared content, LaTeX shell, build/archive helpers | Forever | Header only |
| 2 | `academic`, `industry` | Full content for one base variant each | Forever | Yes |
| 3 | `industry-<role>`, `academic-<role>` | Role-specific tailoring on top of a template | Variable | Yes |

Reasons for each tier:

1. **`main` exists** so shared content has a single canonical source. Without it, shared edits would have to be made on each variant branch separately, with no canonical reference — guaranteed drift. With it, the sync direction is unambiguous (`main` → downstream).
2. **Two base templates exist** (rather than one) because academic and industry are structurally different enough — different section ordering, the academic-only summary paragraph, different research framings — that collapsing them into a single template would reintroduce conditional logic, defeating the point of branches.
3. **Role variant branches exist** for tailoring beyond the base templates. The hyphen-encoded lineage (`<template>-<role>`) makes the parent template visible in the branch name and supports symmetric extension on either side (`industry-quant`, `academic-postdoc-mit`, etc.).

### Sync flow

When `main` updates (a shared edit), the change propagates outward through the hierarchy:

```bash
git checkout main
# edit, commit, push

# Tier 2: rebase the base templates onto main
git checkout academic && git rebase main && git push --force-with-lease
git checkout industry && git rebase main && git push --force-with-lease

# Tier 3: rebase each live role variant onto its parent template
git checkout industry-quant && git rebase industry && git push --force-with-lease
git checkout industry-quantum-consulting && git rebase industry && git push --force-with-lease
# ... etc. for any other live <template>-<role> branches
```

Each propagation is **opt-in**: downstream branches stay at their parent's previous state until you actively rebase. This is intentional — you may not want every shared edit to land on a live role variant mid-application.

`--force-with-lease` is used because rebase rewrites the branch's commit history. It is safe here because variant branches are not shared with other contributors; for a multi-contributor repo, prefer `git merge main` (slower history but no rewrite).

### Historical note

An earlier iteration used `etoolbox` toggle macros (`\academicversion{...}` / `\industryversion{...}`) inside section files on a single `main` branch, with `industry.tex` / `academic.tex` wrapper files setting the `\isacademic` boolean. That approach was retired in commit `00f20bb` once the user's workload shifted from "maintain two static variants" to "produce many tailored variants per application". The toggle macros, the wrapper files, and the `\isacademic` boolean have all been removed; the same role is now played by the branch you have checked out.

## Role-Specific Variants

For tailored CV variants beyond the base academic and industry templates — a quant-focused CV, a quantum-consulting CV, a CV emphasising scientific computing for a specific firm — fork a new branch off the relevant template.

### Branch naming convention

- **Role variants**: `<template>-<role>` — e.g., `industry-quant`, `industry-quantum-consulting`, `academic-postdoc-cambridge`. The `<template>-` prefix encodes the branch's parent, so `git branch | grep '^  industry-'` lists all industry-derived variants. These can be long-lived (you keep iterating as your role understanding improves) or short-lived (one application then archived).
- **Per-application sub-branches** (optional, if you want application-specific snapshots): `<template>-<role>-<application>` — e.g., `industry-quant-citadel-2026`, `academic-postdoc-cambridge-mit-2026`.
- **Archived tags**: `archive/<branch>-YYYY-MM-DD` — e.g., archiving `industry-quant` creates `archive/industry-quant-2026-05-12`.

### Step-by-step workflow

1. **Sync the template and branch off it**:
   ```bash
   git checkout industry           # or academic, depending on which template fits
   git pull
   git rebase main                 # optional: pick up any new shared content from main
   git checkout -b industry-quant industry
   ```

2. **Tailor for the role**: edit `sections/*.tex` (and `sections/section_order.tex` if you want a different ordering). The changes only affect this variant; the template is untouched.

3. **Build the PDF**:
   ```powershell
   .\build_cv.ps1
   ```
   Output: `kyle_wong_cv_<month>_<year>_industry-quant.pdf`.

4. **Submit the PDF** if applying immediately, or commit and keep iterating if maintaining as a long-lived template.

5. **Archive the branch** (when done with it) as a dated tag and delete it:
   ```powershell
   .\archive_branch.ps1 industry-quant
   ```
   (Bash: `./archive_branch.sh industry-quant`.)

   The helper creates `archive/industry-quant-YYYY-MM-DD`, pushes it to `origin`, and deletes the local + remote branch. It refuses to run if the branch is currently checked out, doesn't exist, or already has a tag for today's date.

### Reviving an archived variant

```bash
git checkout -b industry-quant archive/industry-quant-2026-05-12
```

### Listing all archives

```bash
git tag -l "archive/*"
```

### Syncing a live variant with template updates

If `industry` is updated while your variant branch is still active, bring it up to date:

```bash
git checkout industry-quant
git rebase industry
```

Rebase rather than merge: variant branches typically have short, linear histories that don't benefit from merge commits.

### What NOT to do

- **Don't commit a variant-tailored PDF to a template or to `main`.** The PDF lives on the variant branch (and survives via the archive tag). Templates only carry their own variant's PDF; `main` carries no PDF.
- **Don't let variant branches accumulate un-archived.** List them periodically with `git branch | findstr "industry-\|academic-"` (Windows) or `git branch | grep -E '^  (industry-|academic-)'` (Unix) and archive each one whose purpose has been served.

## Documentation

- [Documentation Hub](docs/index.md) — repository overview and CI/automation details.
