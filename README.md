# Lord of the Strings

**A Claude Code plugin that turns Claude into a Third Collaborator for the Giacchetto-Mazenc
gauge-string-matrix triality program.**

Deriving AdS/CFT in the tensionless ($k=1$) limit is a combinatorial war of attrition --
ribbon graphs, Strebel differentials, topological recursion kernels, integer lattice points,
genus expansions -- and humans are bad at not losing signs or missing diagrams at genus one
and beyond. LOTS gives you a research assistant grounded in 21 papers from the triality
literature, organized around four pillars of reasoning (Combinatorialist, Geometer,
Recursionist, Formalist), with 14 specialized skills, 4 lifecycle hooks, and a cross-pillar
mapping dictionary. The preset ships tuned for the triality program: Part I is complete
(`2212.05999`), while DSD-II (B-model derivation via TR) and DSD-III (A-model derivation
via Belyi/KS coset) are in progress -- the corpus includes key precursor papers
(`2412.13397`, `2510.17728`) that feed into the eventual trilogy, along with the $k=1$
localization program and the Kontsevich-Penner model that ties them together.

---

## Table of Contents

1. [Quick Start](#1-quick-start)
2. [The Four Pillars](#2-the-four-pillars)
3. [Skills Reference](#3-skills-reference)
4. [Preset System](#4-preset-system)
5. [The Golden Corpus](#5-the-golden-corpus)
6. [The Mapping Dictionary](#6-the-mapping-dictionary)
7. [Hooks](#7-hooks)
8. [Overleaf Integration](#8-overleaf-integration)
9. [Symbolic Math Engines](#9-symbolic-math-engines)
10. [Lean 4 Formalization](#10-lean-4-formalization)
11. [Configuration](#11-configuration)
12. [Troubleshooting](#12-troubleshooting)
13. [Architecture](#13-architecture)
14. [Making It Yours](#14-making-it-yours)

---

## 1. Quick Start

Five steps from zero to working.

**Step 1 -- Add the marketplace.**

```
/plugin marketplace add inji-kun/lord-of-the-strings
```

**Step 2 -- Install the plugin.**

```
/plugin install lord-of-the-strings@lord-of-the-strings-marketplace
```

That's it. You're done.

**Step 3 -- Start a session.**

Open Claude Code. The `SessionStart` hook fires automatically, loading the persona, preset,
and detecting your symbolic engines. You should see: `LOTS | triality | -- | -- | [░░░░░░░░░░ 0%]`

**Step 4 -- Try a skill.**

```
/fatgraph 3
```

Generates compilable TikZ for a genus-0, 3-face Strebel skeleton. Or ask directly:

> Compute $W^{(1)}_1$ for the Gaussian means spectral curve using topological recursion.

**Step 5 -- Save your session state.**

```
/session-save
```

Persists research context to `config/session-state.md`. The PreCompact hook reinjects this
automatically when the context window compacts.

---

## 2. The Four Pillars

The plugin organizes reasoning into four pillars, each grounded in a subset of the corpus.
Every skill maps to one or more pillars.

| Pillar | Domain | What It Does | Skills | Key Sources |
|--------|--------|-------------|--------|-------------|
| **I. Combinatorialist** | Gauge Theory | Maps Schwinger parameters to ribbon graph edges; enumerates all diagrams; ensures none missed | `series-expand`, `fatgraph`, `check-limits` | `hep-th/0308184`--`0504229`, `2212.05999` |
| **II. Geometer** | String Theory | Proves Strebel cells = gauge theory diagrams; verifies the Schwinger-Strebel mapping (V-type: $l = 1/\tau_{\text{eff}}$, F-type: $l = \tau$) at higher genus | `strebel-solver`, `check-limits`, `topological-recursion` | `1803.04423`, `1812.01007`, `1911.00378`, `2410.13273` |
| **III. Recursionist** | Matrix Models | Applies TR loop equations; computes discrete volumes; using TR to derive the B-model LG dual and connecting matrix model to string theory | `topological-recursion`, `series-expand`, `discrete-volumes` | `1512.09309`, `math-ph/0702045`, `1412.3286`, `math/0111082` |
| **IV. Formalist** | Lean 4 | Translates combinatorial identities into machine-verified Lean 4 theorems | `formalize-lemma` | `math/0101147` |

---

## 3. Skills Reference

### Overview Table

| Skill | Command | What It Does | Preset Narrows To | Needs |
|-------|---------|--------------|-------------------|-------|
| `series-expand` | -- | $1/N$, coupling, genus expansions | Kontsevich-Penner; curve from `1512.09309` | sage/sympy |
| `check-limits` | -- | Verify boundary behavior and limits | Moduli space boundaries per `2212.05999` S5 | -- |
| `topological-recursion` | -- | Compute $W_{g,n}$ via Eynard-Orantin | Gaussian means $yx - y^2 = 1$; `1512.09309` Kpq | sage/sympy |
| `fatgraph` | `/fatgraph` | TikZ ribbon graph diagrams | Strebel skeletons with $l_i$ labels | -- |
| `quiver` | `/quiver` | LaTeX quiver diagrams | $U(N)$ adjoint, $\mathcal{N}=4$ SYM | -- |
| `formalize-lemma` | -- | LaTeX to Lean 4 + `lake build` | Strebel positivity, Euler char, perimeters | lean4 |
| `inspire-search` | -- | Search InspireHEP / arXiv | Pre-filtered to $k=1$ / TR / Strebel | internet |
| `add-reference` | -- | Fetch arXiv source, add to corpus | -- | curl |
| `strebel-solver` | -- | Solve Strebel constraints, enumerate graphs | $g=1$ integer lengths + Belyi permutations | sage/sympy |
| `discrete-volumes` | -- | Lattice-point recursion for $N_{g,s}$ | Recursion from `2510.17728` | sage/sympy |
| `belyi-localization` | -- | Enumerate Belyi maps, covering maps, localization | DSD-III Belyi/dessin program | sage/sympy |
| `kazama-suzuki` | -- | SL(2,R)/U(1) coset at k=1 (A-model worldsheet) | DSD-III target theory | -- |
| `session-save` | `/session-save` | Persist research state | -- | -- |
| `preset` | `/preset` | Switch active preset | -- | -- |

Skills without a slash command are invoked automatically by Claude when contextually
appropriate. Skills with a `/command` can also be triggered explicitly.

---

### Skill Details

<details>
<summary><strong>Computation skills</strong> -- series-expand, topological-recursion, strebel-solver, discrete-volumes</summary>

These four skills share a common pattern: Claude reads equations from the corpus, writes a
sage/sympy/mathematica script, executes via Bash, and interprets the result.

**topological-recursion** -- Computes $W_{g,n}$ correlators. In preset mode, uses the
Gaussian means curve $yx - y^2 = 1$ with Convention A uniformization. Example:

> **You:** Compute $W^{(1)}_1(p_1)$ -- the torus one-point function.
>
> **Claude:** This is the genus-1 seed: $W^{(1)}_1 = \sum_{\text{res}} K(p_1,q)\,B(q,\bar{q})$
> [writes sage script, executes]
> Result: $W^{(1)}_1(p_1) = \frac{e^{2\lambda_1}}{(e^{2\lambda_1} - 1)^2}\,d\lambda_1$

**series-expand** -- $1/N$ expansion of matrix models. In preset mode, locks to
Kontsevich-Penner with spectral curve from `1512.09309`.

**strebel-solver** -- Solves Strebel constraints and enumerates metrized ribbon graphs.
In preset mode, focuses on $g=1$ with integer lengths and Belyi permutations. Example:

> **You:** Enumerate all integer Strebel graphs at $g=1$, $n=1$ with perimeter $P=4$.
>
> **Claude:** [writes sage script to enumerate] Found 3 distinct graphs (up to automorphism).

**discrete-volumes** -- Computes $N_{g,s}(P_1,\ldots,P_s)$ via lattice-point recursion.
In preset mode, uses the recursion from `2510.17728`.

</details>

<details>
<summary><strong>Diagram skills</strong> -- fatgraph, quiver</summary>

**fatgraph** (`/fatgraph`) -- Generates TikZ ribbon graphs. In preset mode, labels edges
with Strebel lengths $l_i$ and enforces perimeter constraints. Example:

> **You:** `/fatgraph 3`
>
> **Claude:** [generates TikZ for genus-0 trivalent graph with 3 faces]
> Euler check: $V - E + F = 2 - 3 + 3 = 2$. OK.

**quiver** (`/quiver`) -- Generates LaTeX quiver diagrams via tikz-cd. In preset mode,
restricts to $U(N)$ adjoint quivers for $\mathcal{N}=4$ SYM subsectors.

</details>

<details>
<summary><strong>Verification skills</strong> -- check-limits, formalize-lemma</summary>

**check-limits** -- Verifies physics expressions in boundary/degeneration limits. In preset
mode, focuses on moduli space boundaries and Strebel degenerations per `2212.05999` S5.

**formalize-lemma** -- Translates LaTeX to Lean 4, runs `lake build`, retries up to 5 times.
In preset mode, targets Strebel positivity, Euler characteristics, perimeter constraints.
Requires Lean 4 + mathlib4. Example:

> **You:** Formalize: $E = 6g - 6 + 3n$ for trivalent ribbon graphs.
>
> **Claude:** [writes Lean 4 theorem, runs `lake build`] Success -- machine-verified.

</details>

<details>
<summary><strong>Literature skills</strong> -- inspire-search, add-reference</summary>

**inspire-search** -- Queries InspireHEP/arXiv. In preset mode, pre-filters to the
tensionless string / $k=1$ / TR / gauge-string community.

**add-reference** -- Fetches arXiv e-prints and adds them to the corpus. Always verifies
the arXiv ID (title + authors) before downloading to prevent hallucinated IDs.

</details>

<details>
<summary><strong>Infrastructure skills</strong> -- session-save, preset</summary>

**session-save** (`/session-save`) -- Persists research state to `config/session-state.md`:

```yaml
---
schema_version: 1
session_id: <current session>
updated_at: 2026-03-22T14:30:00Z
repo_head: abc1234
active_preset: config/presets/triality.md
---
## Current Work
- **File:** main.tex S4.2
- **Computation:** genus 1, 4-point function
## Verified This Session
- Euler characteristic for g=1 4-pt ribbon graphs
## Next Steps
- Compute W^{(1)}_4 using TR skill
```

The PreCompact hook reinjects this when the context compacts.

**preset** (`/preset`) -- Switches the active preset. One write to `config/active-preset.txt`
switches all 14 skills:

```
/preset triality     # activate triality conventions
/preset null         # general mode
```

</details>

---

## 4. Preset System

### What It Is

The preset is a user-editable markdown file (`config/presets/triality.md`) that constrains
Claude's behavior to a specific research domain. Every skill reads `config/active-preset.txt`
at invocation time. If it contains a path (e.g., `config/presets/triality.md`), the skill
loads that file and activates its domain-specific narrowing. If the file is empty, skills run
in general-purpose mode.

### How to Switch

```
/preset triality     # activate the triality preset
/preset null         # general mode (no narrowing)
/preset my-custom    # activate config/presets/my-custom.md
```

### What the Triality Preset Contains

The shipped `triality.md` specifies:

**Conventions:**
- Notation from Giacchetto-Lewanski (`2410.13273`, Les Houches notes)
- Schwinger parameters: $\sigma_i$ or $\tau_i$
- Strebel lengths: $l_i$ or $l_{ij}$
- Integer Strebel: $l_{ij} = n_{ij}$ (number of Wick contractions)
- Always distinguish V-type ($l = 1/\tau_{\text{eff}}$) from F-type ($l = \tau$) mappings

**Spectral curve (Convention A -- for TR recursion kernel, from `1512.09309` S4):**
```
Algebraic equation:  xy - y^2 = 1
Uniformization:      x = e^lambda + e^{-lambda},  y = e^lambda
Branch points:       x = +/-2  (lambda = 0, i*pi)
```

**Spectral curve (Convention B -- for resolvent, from `1512.09309` S3):**
```
x = e^lambda + e^{-lambda},  y = (e^lambda - e^{-lambda})/2
Related to Convention A by:  y_B = y_A - x/2
```

The TR kernel $K(p,q)$ and Bergmann kernel $B(p,q)$ in the Mapping Dictionary use
**Convention A**. When comparing to resolvent-based formulas, use Convention B. Mixing
conventions produces incorrect normalizations.

**Active research focus:**
- DSD-II (unpublished): Derive the B-model dual -- topological Landau-Ginzburg with $W(z) = 1/z + t_2 z$ via topological recursion. Key precursor: `2412.13397` (Strings from Feynman Diagrams)
- DSD-III (unpublished): Derive the A-model dual -- Kazama-Suzuki $\text{SL}(2,\mathbb{R})/U(1)$ at $k=1$ via Belyi maps. Key precursor: `2510.17728` (Matrix Correlators as Discrete Volumes) (Note: the `kazama-suzuki` skill is speculative — DSD-III is unpublished. It is grounded in established literature but the specific derivation is not yet available.)
- The plugin must NOT be overfit to Part I (`2212.05999`) which is complete

**Preferred sources** are mapped per topic (Strebel geometry to `2212.05999`, TR kernels to
`1512.09309`, localization to `1911.00378`/`1812.01007`, discrete volumes to `2510.17728`,
etc.) -- see the file for the full table.

**Euler characteristic warning:** $V - E + F = 2 - 2g$ (graph, $F = n$ faces) vs.
$\chi(\Sigma_{g,n}) = 2 - 2g - n$ (punctured surface). These are different formulas.

The preset also has a **Custom instructions** section for your own notes.

### Editing and Creating Presets

Edit `config/presets/triality.md` directly -- changes take effect on the next skill
invocation. To create a new preset, copy the file, customize, and activate with `/preset your-name`.

---

## 5. The Golden Corpus

21 papers stored as raw LaTeX in `reference/source_tex/`. Each paper lives in its own
directory. Claude reads specific equations on demand via Read/Grep -- nothing is bulk-loaded
into context.

| # | arXiv ID | Title | Authors | Role |
|---|----------|-------|---------|------|
| 1 | `hep-th/0308184` | From Free Fields to AdS | Gopakumar | Genesis |
| 2 | `hep-th/0402063` | From Free Fields to AdS -- II | Gopakumar | Genesis |
| 3 | `hep-th/0504229` | From Free Fields to AdS -- III | Gopakumar | Genesis |
| 4 | `2212.05999` | Deriving the Simplest Gauge-String Duality -- I: Open-Closed-Open Triality | Gopakumar, Mazenc | Part I (planar triality) |
| 5 | `2412.13397` | Strings from Feynman Diagrams | Gopakumar, Kaushik, Komatsu, Mazenc, Sarkar | DSD-II precursor |
| 6 | `2510.17728` | Matrix Correlators as Discrete Volumes of Moduli Space I: Recursion Relations, the BMN-limit and DSSYK | Giacchetto, Maity, Mazenc | DSD-III precursor |
| 7 | `1803.04423` | Tensionless String Spectra on AdS$_3$ | Gaberdiel, Gopakumar | Stringy limit |
| 8 | `1812.01007` | The Worldsheet Dual of the Symmetric Product CFT | Eberhardt, Gaberdiel, Gopakumar | Worldsheet theory |
| 9 | `1911.00378` | Deriving the AdS$_3$/CFT$_2$ Correspondence | Eberhardt, Gaberdiel, Gopakumar | Localization proof |
| 10 | `2009.11306` | Free field world-sheet correlators for AdS$_3$ | Dei, Gaberdiel, Gopakumar, Knighton | Free field correlators |
| 11 | `hep-th/0001053` | Strings in AdS$_3$ and the SL(2,R) WZW Model. Part 1: The Spectrum | Maldacena, Ooguri | AdS$_3$ foundation |
| 12 | `hep-th/0005183` | Strings in AdS$_3$ and the SL(2,R) WZW Model. Part 2: Euclidean Black Hole | Maldacena, Ooguri | AdS$_3$ foundation |
| 13 | `hep-th/0111180` | Strings in AdS$_3$ and the SL(2,R) WZW Model. Part 3: Correlation Functions | Maldacena, Ooguri | AdS$_3$ foundation |
| 14 | `1512.09309` | Topological recursion for Gaussian means and cohomological field theories | Andersen, Chekhov, Norbury, Penner | Loop equations |
| 15 | `2410.13273` | Les Houches lecture notes on moduli spaces of Riemann surfaces | Giacchetto, Lewanski | Primary notation context |
| 16 | `math/0111082` | Matrix Integrals and Feynman Diagrams in the Kontsevich Model | Fiorenza, Murri | Clean Kontsevich source |
| 17 | `math/0101147` | Gromov-Witten theory, Hurwitz numbers, and Matrix models, I | Okounkov, Pandharipande | Lean bridge / intersection theory |
| 18 | `1412.3286` | A short overview of the "Topological recursion" | Eynard | TR dictionary |
| 19 | `math-ph/0702045` | Invariants of algebraic curves and topological expansion | Eynard, Orantin | Foundational TR |
| 20 | `0803.2681` | On a worldsheet dual of the Gaussian matrix model | Razamat | Integer Strebel |
| 21 | `0801.4590` | Counting lattice points in the moduli space of curves | Norbury | Lattice points |

Papers 1--6 build the gauge theory vertex (Gopakumar's program: Part I + DSD-II/III precursors).
Papers 7--13 cover the string theory vertex ($k=1$ worldsheet, localization, SL(2,R) WZW).
Papers 14--21 provide the matrix model vertex (TR, Kontsevich-Penner, discrete volumes).

---

## 6. The Mapping Dictionary

`reference/MAPPING_DICTIONARY.md` is the plugin's single source of truth for cross-pillar
notation. It contains 7 sections with indexed equations from the corpus.

### The Seven Sections

| Section | Title | Primary Source |
|---------|-------|---------------|
| SI | Feynman Graph Topology to Strebel Geometry | `2212.05999` S5 |
| SII | Schwinger to Strebel Length Mapping | `2212.05999` S5.3--5.4 |
| SIII | Topological Recursion Kernels | `1512.09309` S4, `1412.3286` |
| SIV | Kontsevich-Penner Model and Intersection Theory | `1512.09309` S3, `math/0111082` |
| SV | The String Duals: B-Model, A-Model, and Localization | `1812.01007`, `1911.00378`, `2009.11306` |
| SVI | Cross-Pillar Translation Table | All pillars |
| SVII | Supporting Computations for DSD-II and DSD-III | `1512.09309`, `2412.13397`, `2510.17728` |

### The Cross-Pillar Translation Table (Section VI)

This is the core reference table. Each row translates a concept across the three pillars:

| Gauge Theory | String Theory | Matrix Model |
|---|---|---|
| Feynman diagram | Strebel skeleton on $\Sigma_{g,n}$ | Fat graph in cell decomposition of $\mathcal{M}_{g,s}$ |
| Schwinger parameter $\tau$ | Strebel edge length $l$ (V-type: $l = 1/\tau_{\text{eff}}$; F-type: $l = \tau$) | Edge length $l_i \in \mathbb{R}_+$ (or $\mathbb{Z}_+$) |
| $1/N$ expansion at genus $g$ | Worldsheet of genus $g$ | $N^{2-2g}$ term in matrix model |
| $n$-point correlator | $n$ punctures on $\Sigma_{g,n}$ with perimeters $L_i$ | $s$-point function in Kontsevich model |
| Wick contraction count $n_{ij}$ | Integer Strebel length $l_{ij}$ | Integer edge in discrete moduli |
| $V - E + F = 2 - 2g$ (with $F = n$) | $\chi(\Sigma_{g,n}) = 2 - 2g - n$ | Same combinatorics |
| Face of ribbon graph | Pole of Strebel diff. / puncture | Face of fat graph |
| Vertex of ribbon graph | Zero of Strebel diff. | Vertex of fat graph |
| Loop constraint $\sum l_i = P_I$ | Perimeter of asymptotic closed string | Boundary of face in cell decomposition |
| Free field ($k=1$) limit | Tensionless string / $\mathfrak{psu}(1,1\vert 2)_1$ | Covering-map localization |
| Genus $g=1$ diagrams (supporting computation for DSD-II/III) | Torus worldsheet (DSD-II supporting computation) | $W^{(1)}_1 = \sum K(p_1,q)B(q,\bar{q})$ |

---

## 7. Hooks

Four hooks fire automatically at specific points in the Claude Code lifecycle.

### SessionStart -- `hooks/session-start.sh`

Fires on every new session. Runs `git fetch` in the background (never blocks startup),
detects dirty tree, injects persona from `SOUL.md` + active preset + last session state,
and reports available/missing tools:

| Tool | Required By | If Missing |
|------|------------|------------|
| `git` | Sync | Skip fetch, warn |
| `latexmk` / `pdflatex` | LaTeX validation | Hook skips, warn |
| `sage` / `wolframscript` / `python3+sympy` | Symbolic math | Reports which is available |
| `lean` / `lake` | `formalize-lemma` | Skill unavailable |
| `curl` | `add-reference`, `inspire-search` | Skills unavailable |

### PostToolUse: LaTeX Validation -- `hooks/latex-validate.sh`

Fires after any Edit/Write to a `.tex` file. Reads `config/latex-root.txt` for the compile
root, debounces (5s), runs `latexmk -pdf -interaction=nonstopmode -halt-on-error`. On
failure: returns errors for Claude to self-correct. On success: silent.

### PreCompact -- `hooks/pre-compact.sh`

Fires before context compaction. Reinjects `config/session-state.md` so research state
survives. If no state file exists, warns: "Consider running /session-save."

### StatusLine -- `hooks/statusline.sh`

Persistent status bar reading from disk:

```
LOTS | triality | main.tex S4.2 | g=1, 4-pt | [██████░░░░ 62%]
```

Fields: plugin name | preset | current section | computation | context bar (green/yellow/orange/red).
Only shows what has been persisted via `/session-save`.

---

## 8. Overleaf Integration

Overleaf's GitHub sync lets Claude Code edit your paper directly.

### Requirements

- Overleaf Premium (most universities provide institutional access via ETH, etc.)

### Step-by-Step Setup

1. **Link GitHub:** Overleaf > Account Settings > "Link" next to GitHub
2. **Create repo:** Open project in Overleaf > Menu > Sync > GitHub > "Create a GitHub Repository"
3. **Clone:** `git clone https://github.com/your-user/your-project.git && cd your-project`
4. **Set LaTeX root:** `echo "main.tex" > config/latex-root.txt`
5. **Work with Claude Code.** The `latex-validate` hook catches compile errors after every `.tex` edit.
6. **Push:** `git add -A && git commit -m "edits from Claude session" && git push`
7. **Sync:** In Overleaf: Menu > GitHub > "Pull GitHub changes into Overleaf"

### Fallback (No Premium)

1. Download source from Overleaf: Menu > Download > Source
2. Unzip, work locally with Claude Code
3. Re-upload to Overleaf: New Project > Upload Project

See `docs/onboarding.md` for a detailed walkthrough.

---

## 9. Symbolic Math Engines

The plugin auto-detects which engine is available. The SessionStart hook reports what it
finds.

### Preference Order

```
SageMath  >  Mathematica (wolframscript)  >  Python + sympy
```

SageMath is preferred because it handles algebraic geometry and combinatorics natively,
which matters for Strebel differential solving and topological recursion computations.

| Engine | Install | Verify |
|--------|---------|--------|
| SageMath (preferred) | `brew install --cask sage` or [sagemath.org](https://www.sagemath.org/download.html) | `sage --version` |
| Mathematica | Comes with any Mathematica install | `wolframscript -code '1+1'` |
| sympy (fallback) | `pip install sympy` | `python3 -c "import sympy; print(sympy.__version__)"` |

### How Skills Use Engines

Claude reads equations from the corpus, writes a `.py`/`.sage`/`.wls` script, executes via
Bash, and interprets the result. For small computations (Euler characteristics, simple counts),
Claude computes in-prompt without scripting. You can specify a preferred engine in the preset.

---

## 10. Lean 4 Formalization

### Scope

**Realistic now:** parity lemmas, Euler characteristic identities, trivalent edge counts
($E = 6g - 6 + 3n$), finite graph combinatorics, automorphism factors, recursion base cases,
perimeter constraint verification.

**Not realistic near-term:** Strebel differential existence/uniqueness, genus-one moduli-space
geometry, Eynard-Orantin at the algebro-geometric level, $\mathfrak{psu}(1,1|2)_1$
representation theory. These need mathlib4 infrastructure that does not yet exist.

### Setup

```bash
# Install elan (Lean version manager)
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh

# Create a project with mathlib4
lake init my-formalization math && lake build
```

The `formalize-lemma` skill writes `.lean` files and runs `lake build` to verify. On
failure, it reads compiler output, diagnoses, fixes, and retries (max 5 iterations). On
success, the theorem is correct by construction -- Lean's type checker is the proof.

---

## 11. Configuration

All configuration lives in `config/`.

| File | Contents | Written By | Read By |
|------|----------|-----------|---------|
| `config/active-preset.txt` | Path to active preset (e.g., `config/presets/triality.md`) or empty | `/preset` command | Every skill at invocation |
| `config/presets/triality.md` | Notation, spectral curves, research focus, preferred sources | You (editable) | Skills when preset is active |
| `config/session-state.md` | YAML frontmatter + current work, verified results, next steps | `/session-save` skill | SessionStart + PreCompact hooks |
| `config/latex-root.txt` | Path to main `.tex` file (e.g., `main.tex`) | You | `latex-validate` hook |

See [Section 4](#4-preset-system) for the full preset contents.

---

## 12. Troubleshooting

| Problem | Fix |
|---------|-----|
| LaTeX compilation errors | Set `config/latex-root.txt` to your main `.tex` file |
| No symbolic engine detected | Install SageMath (`brew install --cask sage`) or sympy (`pip install sympy`) |
| Lean 4 `lake build` failures | Check `lean-toolchain` matches mathlib4; run `lake update` |
| Overleaf sync conflicts | `git fetch origin && git merge origin/main`, resolve, push |
| Context running out | Run `/session-save`; PreCompact hook preserves state automatically |
| StatusLine shows `--` | Run `/session-save` to populate fields |
| Preset not applying | Run `/preset triality`; check `config/active-preset.txt` |
| Skills not loading | Verify `lord-of-the-strings/skills/*/SKILL.md` exists; check `enabledPlugins` in `settings.json` |
| Wrong normalizations | Convention A: $y = e^\lambda$. Convention B: $y = (e^\lambda - e^{-\lambda})/2$. Do not mix. |
| Euler char mismatch | Graph: $V - E + F = 2 - 2g$. Surface: $\chi = 2 - 2g - n$. Different formulas. |

---

## 13. Architecture

### Design Principles

- **No MCP servers.** No Docker, no managed venvs, no external services. Skills are
  markdown files, hooks are shell scripts, the corpus is `.tex` files on disk.
- **Sharp, not broad.** 14 skills (12 domain, 2 infrastructure), not a general-purpose
  physics toolkit. A scalpel for the triality.
- **Not overfit.** Every skill works in general mode. The preset narrows them when precision
  is needed. Edward can edit the preset or turn it off.
- **On-demand, not bulk.** The 21-paper corpus sits on disk. Claude reads specific equations
  via Read/Grep when a skill needs them. Nothing is bulk-loaded into context. Context budget:
  ~150 lines always-loaded (SOUL.md + preset + session state) + 200-500 lines per skill
  invocation.

### Data Flow

```
SOUL.md + preset + session-state  -->  [12 Skills]  -->  reference/
     (always loaded ~150 lines)      (read corpus       MAPPING_DICTIONARY
                                      on demand          + source_tex/
                                      200-500 lines)     (21 papers)
```

```
[4 Hooks]
  SessionStart   -->  persona injection, git fetch, capability check
  PostToolUse    -->  LaTeX validation after .tex edits
  PreCompact     -->  reinject session state before compaction
  StatusLine     -->  persistent research dashboard
```

The original spec's monolithic Strebel-Schwinger mapper is deliberately distributed across
skills (`fatgraph`, `strebel-solver`, `topological-recursion`, `series-expand`,
`check-limits`) with MAPPING_DICTIONARY SVI as the glue. Claude's reasoning over the
dictionary orchestrates the mapping rather than hardcoding it.

Full design spec: `docs/superpowers/specs/2026-03-22-lord-of-the-strings-design.md`

---

## 14. Making It Yours

### Adding Papers to the Corpus

Use the `add-reference` skill:

> Add 2401.XXXXX to the corpus.

Claude verifies the arXiv ID, downloads the source, extracts it to
`reference/source_tex/[ID]/`, and indexes it. You can then update the preset's preferred
sources to reference the new paper.

### Editing Presets

Modify `config/presets/triality.md` directly. Changes take effect on the next skill
invocation. To create a new preset for a different research program, copy the file and
customize.

### Adding Skills

Create a new `.md` file in `skills/` following the existing pattern. Each skill needs YAML
frontmatter (`name`, `description`), a `<process>` block (must start by reading the active
preset), and a `<preset>` block (domain narrowing when preset is active).

### Reporting Issues

Open an issue on [GitHub](https://github.com/inji-kun/lord-of-the-strings) or tell Claude
directly -- it can file issues via `gh`.

### Updating the Mapping Dictionary

Edit `reference/MAPPING_DICTIONARY.md` directly. Add equations to the appropriate section
and update the cross-pillar table (SVI) if the new paper bridges pillars.

---

## License

See repository for license details.
