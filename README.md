# Kyle Wong CV

A professional Curriculum Vitae authored in LaTeX with multiple variants (academic, industry, role-specific) managed via Git branches. The `main` branch holds shared content only; variant branches (`academic`, `industry`) hold their respective tailored versions; short-lived `role/<name>` branches off the templates carry per-application tailoring.

## Directory Structure

```
kyle_wong_cv/
├── .github/workflows/    # (variant branches only) CI build of the CV PDF
├── .gitignore
├── archive_role.ps1      # Helper: archive a role/<name> branch as a dated tag (PowerShell)
├── archive_role.sh       # Helper: archive a role/<name> branch as a dated tag (Bash)
├── build_cv.ps1          # Build script (PowerShell, Windows) — builds the current branch's variant
├── build_cv.sh           # Build script (Bash, macOS/Linux)   — builds the current branch's variant
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

The build is variant-driven by **which branch you currently have checked out**. The output PDF is named `kyle_wong_cv_<month>_<year>_<branch>.pdf` (forward slashes in branch names become hyphens).

### Windows (PowerShell)

```powershell
git checkout academic        # or industry, or role/<name>
.\build_cv.ps1
```

### macOS / Linux (Bash)

```bash
git checkout academic        # or industry, or role/<name>
./build_cv.sh
```

`main` builds successfully but produces a near-empty PDF (just the header), because section content lives only on variant branches.

## How to Edit

The architecture defines what lives where:

- **`main`** holds the sections that are identical across every variant — Honours, Presentations, Courses, Research Interests, Relevant Experience, Languages, Memberships, Personal Interests, Citizenships — plus the LaTeX shell (`main.tex`, build scripts).
- **`academic`** and **`industry`** are long-lived **template branches**. Each carries its own full content for the variant-specific sections (Education, Research, Repos, Skills), its own `section_order.tex`, and (for academic only) the summary paragraph in `header_summary.tex`.
- **`role/<name>`** are short-lived per-application branches, forked off the relevant template (`industry` for industry-flavoured roles, `academic` for academic-flavoured), then tailored, built, submitted, and archived. See [§Role-Specific Variants](#role-specific-variants).

### Editing shared content

Examples: updating contact info, adding a new course, fixing a typo in Memberships, adding a new language.

1. Check out `main`: `git checkout main`.
2. Edit the relevant `sections/*.tex` file under `sections/` (only shared sections — Honours, Courses, Languages, etc. — live on `main`).
3. Commit and push.
4. **Propagate to variant branches**:
   ```bash
   git checkout academic && git rebase main
   git checkout industry && git rebase main
   ```
   (Repeat for any live `role/<name>` branches that should pick up the change.)

This is the manual-sync cost of the branch-based architecture. It is bounded by how often shared edits happen — typically rare for a CV (address changes, occasional new course or membership).

### Editing variant-specific content

Examples: rephrasing the Research bullets for industry framing, adding an industry-only Skills item, reordering sections for academic.

1. Check out the relevant variant branch: `git checkout academic` (or `industry`, or `role/<name>`).
2. Edit the section file directly. For Research, Repos, Skills, Education, or the academic summary, the variant branch has its own version of the file with content directly written (no toggle macros — the branch IS the variant selector).
3. Build to verify: `.\build_cv.ps1` (or `./build_cv.sh`).
4. Commit and push.

Variant-specific edits do **not** propagate to other branches. Industry's Research wording stays on `industry`; academic's stays on `academic`.

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

The repo uses a **multi-branch architecture** for managing CV variants:

- **`main`**: shared content only. Holds the LaTeX shell (`main.tex`, build scripts) and the section files for the sections that are identical across every variant. The variant-specific section files (Education, Research, Repos, Skills, plus `header_summary.tex` and `section_order.tex`) exist on `main` as **stubs** — empty `\newcommand` definitions and empty include files — so the LaTeX structure is complete but `main` itself builds only the header.

- **`academic`** and **`industry`**: long-lived **template branches**. Each branch overrides the stub files with its own variant-specific content. To get the academic CV: check out `academic` and build. Similarly for industry. The branch IS the variant-selection mechanism — no toggle macros, no `\isacademic`, no wrapper files.

- **`role/<name>`**: short-lived **per-application branches**. Branched off `industry` (or `academic`) for a specific job application, tailored, submitted, then archived as a tag and deleted. See [§Role-Specific Variants](#role-specific-variants).

**Why branches and not toggle macros?** With N variants, the toggle approach scales linearly badly in source-file clutter (each version-specific bullet would carry N adjacent wrappers). The branch approach scales linearly badly in sync ritual (each shared edit needs to be merged into N branches). For a CV — where shared edits are infrequent (an address change, a new course) and version-specific edits are frequent (tailoring for each application) — branches win on total cost.

**Sync flow**: shared edit → `main` → `git rebase main` into `academic` → `git rebase main` into `industry` → `git rebase industry` (or `academic`) into any live `role/<name>` branches.

**Historical note**: an earlier iteration of this repo used `etoolbox` toggle macros (`\academicversion{...}` / `\industryversion{...}`) inside section files on a single `main` branch. That approach was retired in favour of the current branch-based one because the toggle source clutter grew with the number of variants the user needed to maintain. The toggle mechanism, the wrapper files (`industry.tex`, `academic.tex`), and the `\isacademic` boolean have all been removed; the same role is now played by the branch you have checked out.

## Role-Specific Variants

For per-application CV variants (e.g., tailoring for a specific quant firm or research role), use short-lived Git branches off the relevant template (`industry` for industry-flavoured roles, `academic` for academic-flavoured).

### When to use this workflow

- **Yes**: one-shot tailoring for a specific application (emphasise quantitative-finance bullets for a quant fund; reorder sections to put Repos first for a software role).
- **No**: any change that should appear in all future CVs — that belongs on the relevant template (or on `main`, if it's shared).

### Branch naming convention

- **Active branches**: `role/<short-name>` — e.g., `role/quant-firm-x`, `role/ml-startup-y`, `role/research-postdoc-cambridge`.
- **Archived tags**: `archive/role-<short-name>-YYYY-MM-DD` — created at the branch tip after submission; the branch itself is deleted. The date suffix lets you re-apply to the same firm later without name collision.

### Step-by-step workflow

1. **Sync the template and branch off it**:
   ```bash
   git checkout industry        # or academic, depending on which template fits
   git pull
   git rebase main              # optional: pick up any new shared content from main
   git checkout -b role/quant-firm-x industry
   ```

2. **Tailor for the role**: edit `sections/*.tex` (and `sections/section_order.tex` if you want a different ordering for this role). The changes only affect this role's variant; the template is untouched.

3. **Build the PDF**:
   ```powershell
   .\build_cv.ps1
   ```
   (Bash: `./build_cv.sh`.) Output: `kyle_wong_cv_<month>_<year>_role-quant-firm-x.pdf`.

4. **Submit the PDF** to the application.

5. **Archive the branch** as a dated tag and delete it (the included helper does this in one step):
   ```powershell
   .\archive_role.ps1 quant-firm-x
   ```
   (Bash: `./archive_role.sh quant-firm-x`.)

   The helper creates `archive/role-quant-firm-x-YYYY-MM-DD`, pushes it to `origin`, and deletes the local + remote branch. It refuses to run if the branch is currently checked out, if it doesn't exist, or if a tag for today's date already exists for this role.

### Reviving an archived variant

To recreate the branch from an archive — e.g., re-applying to the same firm, or referencing what you submitted:

```bash
git checkout -b role/quant-firm-x archive/role-quant-firm-x-2026-05-12
```

### Listing all archives

```bash
git tag -l "archive/role-*"
```

### Syncing a live role branch with template updates

If `industry` (or `academic`) is updated while your role branch is still active, bring the role branch up to date:

```bash
git checkout role/quant-firm-x
git rebase industry        # or academic, whichever it was branched from
```

Rebase rather than merge: role branches are short-lived; linear history is cleaner.

### What NOT to do

- **Don't commit a role-tailored PDF to `main` or to the template branches.** The PDF lives on the role branch (and survives via the archive tag). Templates only carry their own variant's PDF.
- **Don't let role branches accumulate un-archived.** List them periodically with `git branch | findstr "role/"` (Windows) or `git branch | grep '^  role/'` (Unix) and archive each one whose application has been settled.

## Documentation

- [Documentation Hub](docs/index.md) — repository overview and CI/automation details.
