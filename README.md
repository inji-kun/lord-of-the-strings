# Lord of the Strings

A Claude Code plugin for the **Mazenc-Giacchetto gauge-string-matrix triality program** --
deriving AdS/CFT in the tensionless ($k=1$) limit via Strebel geometry, topological recursion,
and discrete volumes.

---

## Installation

### Claude Code Marketplace

Add the plugin to your Claude Code `settings.json`:

```json
{
  "enabledPlugins": ["lord-of-the-strings"]
}
```

### Local Clone

```bash
git clone https://github.com/inji-kun/lord_of_the_strings.git
cd lord_of_the_strings
```

Then point Claude Code at the cloned directory in your settings.

### Verify Installation

- Check that all 12 skills load (run any slash command, e.g. `/fatgraph`)
- Confirm the statusline appears: `LOTS | triality | ...`
- The `SOUL.md` persona should inject automatically on session start

---

## Quick Start

1. **Start a session** -- the `SessionStart` hook fires automatically, loading the
   research persona from `SOUL.md` and injecting the active preset.

2. **Generate a ribbon graph:**
   ```
   /fatgraph 3
   ```
   Produces compilable TikZ code for a genus-0, 3-face fatgraph.

3. **Switch preset:**
   ```
   /preset triality
   ```
   Narrows all skill behavior to triality-program conventions (spectral curve, notation, etc.).

4. **Compute correlators** -- ask Claude to compute $W_{g,n}$ via topological recursion.
   The plugin auto-detects SageMath, Mathematica, or sympy.

5. **Save your work:**
   ```
   /session-save
   ```
   Persists research state so it survives context compaction.

---

## Skills Reference

| Skill | Command | Description | Needs |
|---|---|---|---|
| topological-recursion | (auto) | Compute $W_{g,n}$ correlators via Eynard-Orantin recursion | sage/sympy |
| series-expand | (auto) | $1/N$ expansion of matrix model quantities | sage/sympy |
| check-limits | (auto) | Verify boundary behavior and known limits | -- |
| strebel-solver | (auto) | Solve Strebel differential constraints | sage/sympy |
| discrete-volumes | (auto) | Lattice-point recursion for Kontsevich volumes | sage/sympy |
| fatgraph | `/fatgraph` | Generate TikZ ribbon graph diagrams | -- |
| quiver | `/quiver` | Generate LaTeX quiver diagrams | -- |
| formalize-lemma | (auto) | Translate LaTeX statements to Lean 4 + verify | lean4/mathlib4 |
| inspire-search | (auto) | Search InspireHEP / arXiv for references | internet |
| add-reference | (auto) | Add papers to the local corpus | curl |
| session-save | `/session-save` | Persist research state to survive compaction | -- |
| preset | `/preset` | Switch the active domain preset | -- |

Skills marked **(auto)** are invoked by Claude when contextually appropriate.
Skills with a **`/command`** can also be triggered explicitly.

---

## Preset System

The preset system constrains Claude's behavior to a specific research domain,
ensuring consistent notation and conventions.

### How It Works

The file `config/active-preset.txt` contains the path to the current preset
(e.g., `config/presets/triality.md`). Every skill reads this file at invocation
and adjusts its behavior accordingly.

### Switching Presets

```
/preset triality     # activate triality conventions
/preset null         # clear preset, return to general mode
```

### Editing a Preset

Directly modify `config/presets/triality.md` to change conventions, spectral
curve choices, or notation rules.

### Creating New Presets

1. Copy `config/presets/triality.md` to `config/presets/your-preset.md`
2. Customize conventions, notation, and scope
3. Activate: `/preset your-preset`

### Recovery

If general mode (no preset) degrades performance or produces inconsistent notation,
switch back to a preset:

```
/preset triality
```

---

## Corpus & Knowledge Base

### The Golden Corpus (21 papers)

The `reference/source_tex/` directory contains full LaTeX source for:

| arXiv ID | Role |
|---|---|
| `2212.05999` | Gopakumar-Mazenc Part I -- planar triality |
| `2412.13397` | Part II -- Strings from Feynman Diagrams ($g=1$) |
| `2510.17728` | Part III -- all-orders proof |
| `2410.13273` | Giacchetto-Lewanski Les Houches notes |
| `1512.09309` | Eynard-Orantin TR on Catalan curve |
| `2009.11306` | Tensionless string review |
| `1911.00378` | Free-field worldsheet |
| `1812.01007` | Symmetric orbifold / tensionless |
| `1803.04423` | Gaberdiel-Gopakumar review |
| `1412.3286` | Lattice point contributions |
| `0803.2681` | Kontsevich lattice volumes |
| `0801.4590` | Norbury-Scott discrete volumes |
| `math-ph/0702045` | Eynard-Orantin topological recursion |
| `hep-th/0504229` | Gopakumar open-closed-open |
| `hep-th/0402063` | Razamat string field theory |
| `hep-th/0308184` | Gopakumar free field realization |
| `hep-th/0111180` | Gopakumar-Vafa derivation |
| `hep-th/0005183` | Gross-Taylor lattice |
| `hep-th/0001053` | Kostov gauge-string |
| `math/0101147` | Kontsevich-Manin moduli |
| `math/0111082` | Zvonkine Strebel review |

### MAPPING_DICTIONARY

`reference/MAPPING_DICTIONARY.md` contains 7 sections correlating notation across
all three pillars of the triality, plus a cross-pillar equation index. This is the
plugin's single source of truth for notation.

### Adding Papers

Use the `add-reference` skill. It always verifies arXiv IDs before downloading:

```
Add the paper 2301.12345 to the corpus.
```

---

## Hooks

Four hooks fire automatically at specific points in the Claude Code lifecycle.

### SessionStart (`hooks/session-start.sh`)

Runs on every new session. Injects the `SOUL.md` persona, loads the active preset
from `config/active-preset.txt`, runs `git fetch`, and detects available symbolic
engines (sage, wolframscript, python/sympy).

### PostToolUse: LaTeX Validation (`hooks/latex-validate.sh`)

After any `.tex` file edit, attempts a compile check to catch errors early.
Requires a LaTeX root file specified in `config/latex-root.txt`.

### PreCompact (`hooks/pre-compact.sh`)

Before Claude Code compacts context, reinjects session state from
`config/session-state.md` so research progress survives compaction.

### StatusLine (`hooks/statusline.sh`)

Displays a persistent status bar:

```
LOTS | triality | sec:IV | sage:ok | [=====     50%]
```

Fields: plugin name | active preset | current section | computation engine | context usage bar.

---

## Overleaf Integration

Overleaf's GitHub sync lets you use Claude Code on your Overleaf project.

### Requirements

- **Overleaf Premium** (most universities provide institutional access)

### Setup

1. **Link GitHub:** Go to Overleaf Account Settings, click "Link" next to GitHub.

2. **Create GitHub repo:** Open your Overleaf project, click Menu (top-left) ->
   Sync -> GitHub -> "Create a GitHub Repository".

3. **Clone locally:**
   ```bash
   git clone https://github.com/your-user/your-project.git
   cd your-project
   ```

4. **Work with Claude Code:** Edit files, run skills, commit changes.

5. **Push to sync:**
   ```bash
   git add -A && git commit -m "edits from Claude Code"
   git push
   ```
   Then in Overleaf: Menu -> GitHub -> "Pull GitHub changes into Overleaf".

### Fallback (No Premium)

If you don't have Overleaf Premium:

1. Download source from Overleaf: Menu -> Download -> Source
2. Unzip, work locally with Claude Code
3. Re-upload to Overleaf: New Project -> Upload Project

See `docs/onboarding.md` for a detailed step-by-step guide.

---

## Symbolic Math Setup

The plugin auto-detects which symbolic engine is available (checked by the
`SessionStart` hook).

### SageMath (Preferred)

```bash
# macOS
brew install --cask sage

# Or download from https://www.sagemath.org/download.html
```

Verify: `sage --version`

### Mathematica

Requires `wolframscript` in your PATH. Comes with any Mathematica installation.

Verify: `wolframscript -code '1+1'`

### Python + sympy (Fallback)

```bash
pip install sympy
```

Verify: `python -c "import sympy; print(sympy.__version__)"`

The plugin prefers SageMath > Mathematica > sympy, in that order.

---

## Lean 4 Setup (Optional)

Lean 4 support enables the `formalize-lemma` skill, which translates LaTeX
statements into Lean 4 proofs verified against mathlib4.

### Install elan (Lean version manager)

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

### Set up a project

Clone or create a project with a `lakefile.lean`, then:

```bash
lake build
```

This downloads mathlib4 and verifies the toolchain.

### Scope

The `formalize-lemma` skill targets **combinatorial and algebraic identities only** --
e.g., lattice-point counts, recursion base cases, combinatorial bijections. It does
not attempt to formalize the analytic core (moduli space integration, Strebel
differential existence).

---

## Troubleshooting

| Problem | Fix |
|---|---|
| LaTeX compilation errors | Check that `config/latex-root.txt` points to your main `.tex` file |
| No symbolic engine detected | Install SageMath (`brew install --cask sage`) or sympy (`pip install sympy`) |
| Lean 4 failures | Verify mathlib4 version with `lake build`; check `lean-toolchain` file |
| Overleaf sync conflicts | Run `git fetch origin` then resolve conflicts manually before pushing |
| Context exhaustion | Run `/session-save`, then start a new Claude Code session -- state auto-restores |
| Statusline not showing | Verify plugin is loaded; check `hooks/statusline.sh` is executable |
| Preset not applying | Check `config/active-preset.txt` contains a valid path |
| Skills not loading | Confirm all `.md` files in `skills/` are present and readable |

---

## Contributing

- **Edit presets:** Modify or add files in `config/presets/`
- **Add papers:** Use the `add-reference` skill to expand the corpus
- **Report issues:** Open an issue on [GitHub](https://github.com/inji-kun/lord_of_the_strings)
- **Extend skills:** Add new `.md` files to `skills/` following the existing format

---

## License

See repository for license details.
