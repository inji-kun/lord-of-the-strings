# Lord of the Strings — Plugin Design Specification

**Date:** 2026-03-22
**Status:** Draft
**Authors:** Bhasi (engineering), Claude (architecture)

---

## 1. Vision

Lord of the Strings is a Claude Code plugin that serves as a specialized Research Assistant (RA) for completing the Mazenc-Giacchetto "Gauge-String-Matrix Triality" trilogy. It provides domain-specific skills, hooks, and a reference corpus that turn Claude into a "Third Collaborator" with combinatorial stamina — grounded in the tensionless string literature and equipped to do symbolic computation, LaTeX editing, formal verification, and literature search.

**Design principles:**
- **Lightweight.** No MCP servers, no Docker, no managed venvs. Skills are markdown, hooks are shell scripts, corpus is `.tex` files on disk.
- **Sharp, not broad.** 10 skills (8 domain, 2 infrastructure), not 61 general commands. A scalpel for the triality, not a Swiss army knife for all of physics.
- **Not overfit.** Every skill works in general-purpose mode. A configurable preset system narrows them to the triality when precision is needed, but Edward can edit the preset or turn it off.
- **On-demand, not bulk.** The 14-paper corpus sits on disk. Claude reads specific equations via Read/Grep when a skill needs them. Nothing is bulk-loaded into context.

---

## 2. Distribution & Installation

### 2.1 Distribution Model

GitHub repo with a `.claude-plugin/marketplace.json` manifest. Users install via Claude Code's plugin system (settings.json `enabledPlugins` entry pointing at the repo) or by cloning locally.

No npm bootstrap, no Python venv, no build step. The plugin is entirely static files (markdown skills, shell hooks, `.tex` corpus, config).

### 2.2 Repo Structure

```
lord-of-the-strings/
├── .claude-plugin/
│   └── marketplace.json
├── skills/
│   ├── series-expand.md
│   ├── check-limits.md
│   ├── topological-recursion.md
│   ├── fatgraph.md
│   ├── quiver.md
│   ├── formalize-lemma.md
│   ├── inspire-search.md
│   ├── add-reference.md
│   ├── session-save.md            # Persist research state to disk
│   └── preset.md                  # Switch active preset across all skills
├── hooks/
│   ├── session-start.sh
│   ├── latex-validate.sh
│   ├── pre-compact.sh
│   └── statusline.sh
├── config/
│   ├── presets/
│   │   └── triality.md           # User-editable domain preset
│   ├── active-preset.txt         # Points to current preset (written by /preset command)
│   └── session-state.md          # Written by /session-save skill, read by hooks
├── reference/
│   ├── MAPPING_DICTIONARY.md
│   └── source_tex/               # 14-paper Golden Corpus
│       ├── 2212.05999/
│       ├── 2412.13397/
│       ├── 2510.17728/
│       ├── 1803.04423/
│       ├── 1812.01007/
│       ├── 1512.09309/
│       ├── 2410.13273/
│       ├── math.0111082/
│       ├── math_0101147/
│       ├── 1412.3286/
│       ├── math-ph_0702045/
│       ├── hep-th_0308184/
│       ├── hep-th_0402063/
│       └── hep-th_0504229/
├── SOUL.md                        # Persona & operational principles
├── CLAUDE.md                      # Claude Code project instructions
├── SPECS.md                       # Original functional spec
├── README.md                      # Comprehensive documentation
└── docs/
    ├── onboarding.md              # Overleaf GitHub sync setup guide
    └── superpowers/specs/         # This file
```

### 2.3 Installation Steps

1. Edward adds the plugin to his Claude Code settings (marketplace or local path)
2. Claude Code loads skills, hooks, and CLAUDE.md automatically
3. One-time: Edward links his Overleaf project to GitHub (documented in `docs/onboarding.md`)
4. One-time (optional): Edward configures his symbolic math engine preference in the preset

---

## 3. Skills

### 3.1 Skill Architecture

Each skill is a markdown file with YAML frontmatter, following the GPD-established pattern:

```yaml
---
name: skill-name
description: One-line description
preset: config/presets/triality.md   # or null for general mode
---

<objective>...</objective>
<process>...</process>
<output>...</output>
```

When `preset` points to a file, its contents are loaded as additional context. When `preset: null`, the skill runs general-purpose. Skills reference the corpus via explicit pointers ("Read MAPPING_DICTIONARY.md §III") rather than bulk-loading.

### 3.2 Preset System

The preset file (`config/presets/triality.md`) is a user-editable markdown document containing:

- **Conventions:** Notation, variable names, preferred citation style
- **Spectral curve:** The active spectral curve for TR computations
- **Active conjecture:** What Part II/III problem is currently being worked on
- **Preferred sources:** Which corpus papers to consult first per topic
- **Custom instructions:** Anything Edward wants to add

Each skill embeds its domain-specific narrowing inside a `<preset>` block that is only active when the preset file is loaded. Example:

```markdown
<preset>
You are expanding a Kontsevich-Penner matrix model in the 1/N parameter.
Use the conventions from reference/MAPPING_DICTIONARY.md Section IV.
The spectral curve is yx - y^2 = 1 (Gaussian means).
</preset>
```

**Recovery path:** If performance degrades with the general skill, Edward switches back to the triality preset. Both general and preset-narrowed versions ship in every skill file.

### Preset Switching Mechanism

A shared file `config/active-preset.txt` contains the path to the current preset (e.g., `config/presets/triality.md`) or is empty for general mode. Skills read this file at invocation time to determine whether to load the preset.

The `/preset` command is a skill that writes to this file:
- `/preset triality` → writes `config/presets/triality.md` to `active-preset.txt`
- `/preset null` → clears the file (general mode)
- `/preset my-custom` → writes `config/presets/my-custom.md`

This avoids modifying skill frontmatter at runtime — the indirection through a shared config file means one write switches all skills.

### 3.3 Skill Inventory

**Note on the Strebel-Schwinger Mapper:** SPECS.md (Section 2A) specified a dedicated mapper tool that takes a Feynman diagram adjacency list, generates the dual ribbon graph, computes Euler characteristic, solves Strebel conditions, and outputs the moduli space integrand. In this design, that functionality is deliberately distributed across skills rather than concentrated in one tool: `fatgraph` handles ribbon graph generation, `series-expand` handles the 1/N expansion, `topological-recursion` handles the moduli space integrand, and `check-limits` verifies boundary conditions. The cross-pillar translation table in MAPPING_DICTIONARY.md §VI provides the glue. This distribution is more flexible — the mapper's logic is orchestrated by Claude's reasoning over the MAPPING_DICTIONARY rather than hardcoded in a single tool.

**Note on dropped Lean capabilities:** SPECS.md mentioned `proof_search` (automated tactic application via `aesop`/`omega`) and `moduli_space_definitions` (RAG bridge to mathlib4 moduli space formalizations). These are subsumed by the `formalize-lemma` skill: Claude naturally uses `aesop`, `omega`, `ring`, and other tactics when writing Lean proofs, and can search mathlib4 definitions via Grep on the mathlib4 source or WebFetch on the mathlib4 docs site. Separate tools for these would add complexity without benefit.

#### `series-expand`
- **General:** Expand any matrix model or field theory in a specified parameter (1/N, coupling constant, genus).
- **Preset narrows to:** Kontsevich-Penner 1/N expansion. Spectral curve from `1512.09309`. Conventions from `2410.13273`.
- **Method:** Claude writes a sympy/sage/mathematica script, executes via Bash, interprets the output. Detects which engine is available (checks for `sage`, `wolframscript`, falls back to `python3 -c "import sympy"`).

#### `check-limits`
- **General:** Verify a physics expression in specified limits or boundaries.
- **Preset narrows to:** Moduli space boundary divergences, Strebel degeneration limits. References `2212.05999` §5 for boundary behavior.
- **Method:** Prompt-driven analysis. May invoke symbolic computation for explicit limit checks.

#### `topological-recursion`
- **General:** Compute Eynard-Orantin $W_{g,n}$ correlators for any spectral curve.
- **Preset narrows to:** Gaussian means spectral curve ($yx - y^2 = 1$). Recursion kernel from `1512.09309` Eq. `Kpq`. Bergmann kernel from Eq. `Bpq`.
- **Method:** Claude writes the recursion computation as a sympy/sage script, executes, returns symbolic result. For small $(g,n)$, can compute analytically in-prompt using the MAPPING_DICTIONARY equations.
- **Corpus pointers:** MAPPING_DICTIONARY §III (recursion kernels), §VII (Part II targets).

#### `fatgraph`
- **General:** Generate TikZ code for a ribbon graph with specified genus, valency, and edge structure.
- **Preset narrows to:** Strebel skeletons with perimeter constraints. Labels edges with Strebel lengths $l_i$.
- **Method:** Prompt-driven TikZ generation. Claude produces compilable LaTeX.
- **Invocable as:** `/fatgraph [edges]`

#### `quiver`
- **General:** Generate LaTeX for a gauge theory quiver diagram.
- **Preset narrows to:** $U(N)$ adjoint quivers relevant to $\mathcal{N}=4$ SYM subsectors.
- **Method:** Prompt-driven LaTeX generation using `tikz-cd` or `quiver` package.
- **Invocable as:** `/quiver [nodes]`

#### `formalize-lemma`
- **General:** Translate a LaTeX equation into a Lean 4 theorem statement, then verify via `lake build`.
- **Preset narrows to:** Strebel positivity, Euler characteristic computations, perimeter constraints. Uses mathlib4 conventions.
- **Method:**
  1. Claude reads the LaTeX equation (from a `.tex` file or user input)
  2. Claude writes a `.lean` file with the theorem statement
  3. Runs `lake build` via Bash
  4. If error: reads compiler output, diagnoses the issue, fixes the `.lean` file, retries (max 5 iterations)
  5. If success: the theorem is correct by construction (Lean's type checker is the rigor)
  6. **If 5 failures:** Claude reports the best attempt, shows the last compiler error, explains what it tried, and suggests the user check: (a) mathlib4 version compatibility, (b) whether the LaTeX statement assumes definitions not yet in mathlib, (c) whether the statement needs manual decomposition into smaller lemmas
- **No external dependencies** beyond a working Lean 4 + mathlib4 installation.

#### `inspire-search`
- **General:** Search InspireHEP and arXiv for papers on any physics topic.
- **Preset narrows to:** Pre-filtered to tensionless string / $k=1$ / topological recursion / Strebel / gauge-string duality community.
- **Method:** Uses WebFetch to query `inspirehep.net/api/literature?q=...`, parses JSON response, returns formatted results with arXiv links.

#### `add-reference`
- **General:** Fetch an arXiv e-print, extract the raw LaTeX source, add it to the corpus.
- **Method:**
  1. Takes an arXiv ID as input
  2. **Verifies the ID** by fetching `arxiv.org/abs/[ID]` and confirming title/authors match the user's intent (critical — Gemini-supplied IDs are frequently hallucinated)
  3. Downloads via `curl -L https://arxiv.org/e-print/[ID]`
  4. Extracts, identifies main `.tex`, renames to `[ID]_main.tex`
  5. Appends entry to a corpus index
- **Constraint:** Always verify before download. Display title and authors for user confirmation.

---

## 4. Hooks

### 4.1 SessionStart — `hooks/session-start.sh`

**Event:** SessionStart
**Purpose:** Initialize the RA persona and sync the working repo.

**Actions:**
1. **Background git pull** (detached process, following GPD's pattern — never blocks session start). Reports changes in `systemMessage` if any files were updated.
2. **Inject persona context:** Reads SOUL.md (~100 lines), active preset (~30 lines), and session state from last session (~20 lines). Delivers as `additionalContext`.
3. **Report research position:** If `config/session-state.md` exists, includes "Last session: working on §X, computing genus-g Y-point function, verified Z."

**Output:** JSON with `systemMessage` (git status) and `hookSpecificOutput.additionalContext` (persona + state).

### 4.2 PostToolUse (Edit/Write `*.tex`) — `hooks/latex-validate.sh`

**Event:** PostToolUse
**Matcher:** `Edit|Write`
**Purpose:** Validate LaTeX compilation after every edit to a `.tex` file.

**Actions:**
1. Extract file path from stdin JSON (`tool_input.file_path` or `tool_response.filePath`)
2. Check if it's a `.tex` file (skip otherwise)
3. Run `latexmk -pdf -interaction=nonstopmode -halt-on-error` (or `pdflatex` fallback)
4. If compilation fails: return errors in `hookSpecificOutput.additionalContext` so Claude can self-correct
5. If compilation succeeds: silent (no output)

**Constraint:** Non-blocking. Runs with a timeout (30s). If `latexmk` isn't installed, skip gracefully.

### 4.3 Session State: `/session-save` Skill + PreCompact Hook

**Problem:** A shell-script hook cannot observe conversation-level semantic state (what section Claude was editing, what computation was in progress). Only Claude itself has this knowledge.

**Solution: Two-part design.**

**Part A: `/session-save` skill** — A skill that Claude invokes (or Edward invokes explicitly) to persist research state. Claude writes `config/session-state.md` with:
- Current `.tex` file and section being edited
- Active computation (genus, number of points, what's being verified)
- Identities verified this session
- Open questions / next steps

Claude has full conversation context, so this state is semantically rich. The SOUL.md persona instructs Claude to invoke `/session-save` periodically during long sessions.

**Part B: PreCompact hook** (`hooks/pre-compact.sh`) — Fires on PreCompact. Reads the existing `config/session-state.md` (written by Claude via Part A) and injects it as `hookSpecificOutput.additionalContext` so the post-compaction context retains research state. The hook does NOT generate state — it only reads and reinjects what Claude already persisted.

If `session-state.md` does not exist (Claude never saved) or is stale (older than the current session), the hook emits a warning in `additionalContext`: "Research state not saved this session. Consider running /session-save to preserve your progress." This prevents silent degradation of session continuity.

### 4.4 StatusLine — `hooks/statusline.sh`

**Event:** StatusLine (continuous)
**Purpose:** Display a compact research dashboard.

**Format:**
```
LOTS | triality | main.tex §4.2 | g=1, 4-pt | [████████░░ 62%]
```

**Data sources (all from disk, not from conversation state):**
- `LOTS` — hardcoded plugin identifier
- Active preset name — read from `config/active-preset.txt` (or `general` if empty)
- Current section + computation — read from `config/session-state.md` (written by `/session-save` skill). If the file doesn't exist, these fields show `—`.
- Context usage bar — computed from the `context_window` field in the stdin JSON payload (color-coded: green < 63%, yellow < 81%, orange < 95%, red >= 95%, scaled to 80% of raw capacity following GPD's pattern)

**Constraint:** The statusline only displays what has been persisted to disk. It cannot observe the live conversation. The quality of the statusline depends on Claude (or Edward) invoking `/session-save` periodically.

**Reads from stdin:** JSON with `session_id`, `model`, `context_window` fields.

---

## 5. Corpus & RAG Strategy

### 5.1 The Golden Corpus

14 papers stored as raw LaTeX in `reference/source_tex/`. Each paper in its own directory with the main file renamed to `[ID]_main.tex`. Supporting files (figures, `.bbl`, `.bst`, style files) preserved for local compilation.

| # | Role | arXiv ID | Short Title |
|---|------|----------|-------------|
| 1-3 | Genesis | `hep-th/0308184`, `0402063`, `0504229` | From Free Fields to AdS I–III |
| 4 | The Program | `2212.05999` | Simplest Gauge-String Duality I |
| 5 | Non-planar | `2412.13397` | Non-planar Correlators |
| 6 | Discrete Volumes | `2510.17728` | Matrix Correlators as Discrete Volumes |
| 7 | Stringy Limit | `1803.04423` | Tensionless String Spectra on AdS3 |
| 8 | Worldsheet | `1812.01007` | Worldsheet Dual of Symmetric Product CFT |
| 9 | Loop Equations | `1512.09309` | TR for Gaussian means / Kontsevich-Penner |
| 10 | Primary Context | `2410.13273` | Les Houches notes on Moduli Spaces |
| 11 | Clean Slate | `math/0111082` | Kontsevich Model via Feynman Diagrams |
| 12 | Lean Bridge | `math/0101147` | GW theory, Hurwitz numbers, Matrix models |
| 13 | TR Dictionary | `1412.3286` | Short Overview of Topological Recursion |
| 14 | Foundational TR | `math-ph/0702045` | Invariants of Algebraic Curves |

### 5.2 Access Pattern

**Library, not textbook.** The corpus is never bulk-loaded.

- **Skills contain pointers:** e.g., "Read MAPPING_DICTIONARY.md §III for the recursion kernel"
- **Claude uses Read/Grep tools** to pull specific equations on demand (50-100 lines per lookup)
- **The preset lists preferred sources per topic** so Claude knows where to look first

**Context budget per interaction:** ~150 lines always-loaded (SOUL.md + preset + session state) + 200-500 lines per skill invocation. Well within any context window.

### 5.3 MAPPING_DICTIONARY.md

The cross-pillar equation index, organized by:
- §I: Feynman Graph Topology → Strebel Geometry (from `2212.05999`)
- §II: Schwinger ↔ Strebel Length Mapping (from `2212.05999`)
- §III: Topological Recursion Kernels (from `1512.09309`, `1412.3286`)
- §IV: Kontsevich-Penner Model & Intersection Theory (from `1512.09309`, `math/0111082`)
- §V: Localization & the $k=1$ Worldsheet (from `1812.01007`)
- §VI: Cross-Pillar Translation Table
- §VII: Key Equations for Part II (genus 1)

### 5.4 Growing the Corpus

The `add-reference` skill allows Edward to add papers at any time. It verifies the arXiv ID, downloads, extracts, and indexes. The preset can be updated to reference new papers.

---

## 6. LaTeX Editing & Overleaf Integration

### 6.1 Editing Model

Claude edits `.tex` files directly in a git repo using the standard Edit/Write tools. No special LaTeX tooling — Claude understands LaTeX natively.

The `latex-validate` hook catches compilation errors after every edit and feeds them back to Claude for self-correction.

### 6.2 Overleaf Integration (Option A: GitHub Sync)

**Requires:** Overleaf Premium (institutional access at most universities).

**One-time setup (documented in `docs/onboarding.md`):**
1. Edward creates a GitHub repo from his Overleaf project (Overleaf → Menu → Sync → GitHub)
2. Edward clones the repo locally
3. Claude Code works on the local clone
4. Claude commits and pushes changes
5. Edward clicks "Pull from GitHub" in Overleaf to see changes

**Fallback (no Premium):** Edward downloads `.tex` files from Overleaf, works locally with Claude, re-uploads manually.

The SessionStart hook auto-pulls the latest from the GitHub remote so Claude always sees the most recent version.

---

## 7. Symbolic Computation

### 7.1 No MCP Server

Claude writes computation scripts inline, executes via Bash, and interprets the output. This avoids MCP server dependencies while leveraging Claude's ability to write correct sympy/sage/mathematica code.

### 7.2 Engine Detection

The `topological-recursion` and `series-expand` skills detect the available engine:

1. Check for `sage` (SageMath) — primary target for this project
2. Check for `wolframscript` (Mathematica)
3. Fall back to `python3 -c "import sympy"` (always available if Python is installed)

The preset can specify a preferred engine to skip detection.

### 7.3 Computation Pattern

```
Skill invoked → Claude reads equations from corpus →
Claude writes .py/.sage/.wls script → Bash executes →
Claude reads stdout → interprets and presents result
```

For small computations (e.g., Euler characteristic, simple combinatorial counts), Claude computes in-prompt without scripting.

---

## 8. Lean 4 Formalization

### 8.1 No External Dependencies

The `formalize-lemma` skill requires only a working Lean 4 + mathlib4 installation (which Edward would set up independently for his formalization work).

### 8.2 Translation & Verification Loop

1. Claude reads the LaTeX equation
2. Claude writes a `.lean` file with the theorem statement using mathlib4 conventions
3. Claude runs `lake build` via Bash
4. If error: Claude reads the compiler output, diagnoses the issue, fixes the `.lean` file, retries (max 5 iterations)
5. If success: the theorem is correct by construction — Lean's type checker is the rigor

**No LeanAide dependency.** Claude is the translator; Lean is the verifier. Adding an intermediate LLM (LeanAide calls GPT) would add complexity without clear benefit.

---

## 9. README Specification

The README.md must comprehensively document:

### Installation
- Claude Code marketplace installation
- Local clone installation
- Verifying the plugin loaded (checking skills, hooks, statusline)

### Onboarding
- Overleaf GitHub sync setup (step-by-step with screenshots)
- Fallback for non-Premium Overleaf users
- Symbolic math engine setup (Sage, Mathematica, sympy)
- Lean 4 + mathlib4 setup (optional)

### Skills Reference
- Full documentation of each skill: purpose, usage, examples
- General mode vs. preset mode explained
- How to invoke `/fatgraph` and `/quiver` commands

### Preset System
- What the preset is and where it lives (`config/presets/triality.md`)
- How to edit it
- How to create new presets for different research programs
- How to toggle presets via the `/preset` command
- **Recovery path:** How to re-enable the narrow preset if general mode degrades performance

### Corpus Management
- What's in the Golden Corpus and why
- How to add new papers via `add-reference`
- How the MAPPING_DICTIONARY works
- How to update the corpus index

### Hooks
- What each hook does
- How to disable a hook if it causes issues
- StatusLine format explanation

### Configuration
- `config/presets/triality.md` format and fields
- `config/session-state.md` (auto-generated, but readable)
- `.claude/settings.local.json` permissions

### Troubleshooting
- LaTeX compilation errors after edits
- Symbolic math engine not detected
- Lean 4 `lake build` failures
- Overleaf sync conflicts
- Context window running out during long sessions

---

## 10. Success Criteria

### Part II (Higher Genus)
- Can the plugin successfully identify all $g=1$ ribbon graphs for a 4-point function?
- Can the `topological-recursion` skill compute $W^{(1)}_1$ using the correct kernel?
- Can `check-limits` verify that non-planar integrands are finite at moduli space boundaries?
- Can `formalize-lemma` produce a valid Lean proof that Strebel lengths are positive for $g=1$?

### Part III (The Partition Function)
- Can the plugin perform the series expansion to show the sum over all $g,n$ matches the matrix model?
- Can `topological-recursion` compute $W^{(g)}_n$ recursively to genus 3+?
- Can the cross-pillar translation table in MAPPING_DICTIONARY be used to verify gauge = string = matrix at each genus?

### UX
- Edward can start a Claude Code session and immediately have the RA persona active
- Edits to `.tex` files compile correctly (validated by hook)
- The preset is easy to understand and edit
- Adding a new reference paper takes < 2 minutes
