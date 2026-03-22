> **Historical note:** This is the original spec from before the DSD-II/III framing correction. See SOUL.md for the current understanding of Parts II and III.

# Lord of the Strings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude Code plugin that serves as a specialized research assistant for the Giacchetto-Mazenc gauge-string-matrix triality program.

**Architecture:** No MCP servers. 12 markdown skills (10 domain, 2 infrastructure), 4 shell-script hooks, a 21-paper LaTeX corpus accessed on-demand, and a user-editable preset system. Distributed as a GitHub repo with a `.claude-plugin/marketplace.json` manifest.

**Tech Stack:** Markdown (skills), Bash (hooks), LaTeX (corpus), YAML frontmatter (metadata), JSON (marketplace manifest, hook payloads).

**Spec:** `docs/superpowers/specs/2026-03-22-lord-of-the-strings-design.md`

**Key references:**
- `SOUL.md` — persona and operational principles
- `reference/MAPPING_DICTIONARY.md` — cross-pillar equation index
- `.claude/CLAUDE.md` — development instructions (use Gemini for physics review, Codex for engineering review)

---

## Conventions for All Skills (Tasks 9-18)

Every domain skill markdown file follows the same structure defined in spec §3.1:

```markdown
---
name: skill-name
description: One-line description
---

<process>
1. Read config/active-preset.txt to determine if a preset is active.
2. If a preset path is specified, Read that file and apply its conventions.
3. [skill-specific logic — 20-40 lines]
</process>

<preset>
[Domain-specific narrowing — only applied when preset is active. 10-20 lines.]
</preset>

<output>
[What the skill produces — TikZ code, symbolic result, Lean theorem, etc.]
</output>
```

Skills should be 40-80 lines total. Include example invocations where helpful. Always reference specific MAPPING_DICTIONARY sections by number (§I, §III, etc.).

## Hook Output JSON Contract

All hooks that produce output MUST use this exact JSON structure:

```json
{
  "systemMessage": "Text shown to the user in the UI",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart|PostToolUse|PreCompact",
    "additionalContext": "Text injected into Claude's context"
  }
}
```

The statusline hook is the exception — it outputs a raw ANSI string (not JSON).

If a hook has nothing to report, it exits silently with no stdout.

---

## Task 1: Plugin Manifest & CLAUDE.md

**Files:**
- Create: `.claude-plugin/marketplace.json`
- Create: `CLAUDE.md` (project root — this is what Edward sees, not our dev `.claude/CLAUDE.md`)

- [ ] **Step 1: Create marketplace.json**

```json
{
  "name": "lord-of-the-strings",
  "version": "0.1.0",
  "description": "Research assistant for the Gauge-String-Matrix Triality program. Specialized skills for Strebel differentials, topological recursion, Lean 4 formalization, and LaTeX editing in the tensionless (k=1) limit.",
  "author": {
    "name": "Bhasi",
    "url": "https://github.com/bhasi"
  }
}
```

Write this to `.claude-plugin/marketplace.json`.

- [ ] **Step 2: Create the user-facing CLAUDE.md**

Copy `CLAUDE_EXAMPLE.md` to `CLAUDE.md` at the project root **without modification**. The example file already contains the RA persona instructions that Edward needs. This is distinct from `.claude/CLAUDE.md` which is our gitignored dev instructions.

- [ ] **Step 3: Verify plugin structure**

Run: `ls -la .claude-plugin/marketplace.json CLAUDE.md`
Expected: Both files exist.

- [ ] **Step 4: Commit**

```bash
git add .claude-plugin/marketplace.json CLAUDE.md
git commit -m "feat: add plugin manifest and user-facing CLAUDE.md"
```

---

## Task 2: Preset System (Infrastructure)

**Files:**
- Create: `config/presets/triality.md`
- Create: `config/active-preset.txt`
- Create: `skills/preset.md`
- Test: `tests/presets/test-preset-switch.sh`

- [ ] **Step 1: Write the preset test**

Create `tests/presets/test-preset-switch.sh`:

```bash
#!/bin/bash
set -e

# Test 1: Write preset path
echo "config/presets/triality.md" > config/active-preset.txt
CONTENT=$(cat config/active-preset.txt)
[ "$CONTENT" = "config/presets/triality.md" ] || { echo "FAIL: preset write"; exit 1; }

# Test 2: Clear preset (general mode)
> config/active-preset.txt
[ ! -s config/active-preset.txt ] || { echo "FAIL: preset clear"; exit 1; }

# Test 3: Preset file exists and is readable
[ -f config/presets/triality.md ] || { echo "FAIL: triality.md missing"; exit 1; }

echo "PASS: all preset tests"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash tests/presets/test-preset-switch.sh`
Expected: FAIL (files don't exist yet)

- [ ] **Step 3: Create the triality preset**

Create `config/presets/triality.md` with the content from spec §3.2. This is the user-editable domain preset containing:
- Conventions (notation from Giacchetto-Lewanski `2410.13273`)
- Spectral curve (Convention A: `xy - y^2 = 1`, `x = e^λ + e^{-λ}`, `y = e^λ`)
- Active conjecture (Part II: non-planar g=1 mapping)
- Preferred sources per topic
- Custom instructions section for Edward

- [ ] **Step 4: Create active-preset.txt**

```bash
echo "config/presets/triality.md" > config/active-preset.txt
```

- [ ] **Step 5: Create the /preset skill**

Create `skills/preset.md`:

```yaml
---
name: preset
description: Switch the active preset for all skills
---
```

Body: The skill reads the user's argument (`triality`, `null`, or a custom name), writes the corresponding path to `config/active-preset.txt`, and confirms the switch. If `null`, clears the file.

- [ ] **Step 6: Run test to verify it passes**

Run: `bash tests/presets/test-preset-switch.sh`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add config/ skills/preset.md tests/presets/
git commit -m "feat: add preset system with triality preset and /preset command"
```

---

## Task 3: MAPPING_DICTIONARY Audit

**Files:**
- Verify/modify: `reference/MAPPING_DICTIONARY.md`

The existing MAPPING_DICTIONARY is referenced by every domain skill via section pointers (e.g., "Read MAPPING_DICTIONARY §III"). A subagent must verify that all seven sections exist and are correctly populated.

- [ ] **Step 1: Verify all sections exist**

Read `reference/MAPPING_DICTIONARY.md` and confirm these sections are present:
- §I: FEYNMAN GRAPH TOPOLOGY → STREBEL GEOMETRY
- §II: SCHWINGER ↔ STREBEL LENGTH MAPPING
- §III: TOPOLOGICAL RECURSION KERNELS
- §IV: KONTSEVICH-PENNER MODEL & INTERSECTION THEORY
- §V: LOCALIZATION & THE k=1 WORLDSHEET
- §VI: CROSS-PILLAR TRANSLATION TABLE
- §VII: KEY EQUATIONS FOR PART II (GENUS 1)

If any section is missing or incomplete, flag it.

- [ ] **Step 2: Verify key equations are present**

Spot-check that these specific items are in the dictionary:
- Strebel's Theorem bijection (§I)
- V-type and F-type Schwinger↔Strebel formulas (§II)
- Convention A and B spectral curves with explicit relationship (§III)
- Recursion kernel K(p,q) and Bergmann kernel B(p,q) (§III)
- Eynard-Orantin recursion for W^{(g)}_s (§III)
- Kontsevich matrix integral (§IV)
- Integer Strebel parity note (§IV)
- Localization citing `1911.00378` with conjectural-at-higher-genus note (§V)
- Corrected Euler characteristic: V-E+F = 2-2g for graph, χ(Σ_{g,n}) = 2-2g-n for surface (§I and §VI)

- [ ] **Step 3: Commit if changes needed**

```bash
git add reference/MAPPING_DICTIONARY.md
git commit -m "fix: audit and verify MAPPING_DICTIONARY sections"
```

---

## Task 4: Session State (Infrastructure)  *(was Task 3)*

**Files:**
- Create: `skills/session-save.md`
- Create: `tests/hooks/pre-compact/session-state-fresh.md` (fixture)
- Create: `tests/hooks/pre-compact/session-state-stale.md` (fixture)

- [ ] **Step 1: Create session-save skill**

Create `skills/session-save.md`:

```yaml
---
name: session-save
description: Persist current research state to disk for session continuity
---
```

Body: The skill instructs Claude to write `config/session-state.md` with YAML frontmatter (`schema_version: 1`, `session_id`, `updated_at`, `repo_head`, `active_preset`) and markdown body sections (Current Work, Verified This Session, Open Questions, Next Steps). Claude fills these from conversation context.

- [ ] **Step 2: Create test fixtures**

Create `tests/hooks/pre-compact/session-state-fresh.md`:

```yaml
---
schema_version: 1
session_id: test-session-001
updated_at: "2026-03-22T12:00:00Z"
repo_head: abc123
active_preset: config/presets/triality.md
---

## Current Work
- **File:** main.tex §4.2
- **Computation:** genus 1, 4-point function
```

Create `tests/hooks/pre-compact/session-state-stale.md` with `updated_at: "2025-01-01T00:00:00Z"`.

- [ ] **Step 3: Commit**

```bash
git add skills/session-save.md tests/hooks/pre-compact/
git commit -m "feat: add session-save skill and test fixtures"
```

---

## Task 5: SessionStart Hook

**Files:**
- Create: `hooks/session-start.sh`
- Create: `tests/hooks/session-start/payload-clean-repo.json`
- Create: `tests/hooks/session-start/expected-clean-repo.json`

- [ ] **Step 1: Write the hook contract test payload**

Create `tests/hooks/session-start/payload-clean-repo.json`:

```json
{"session_id": "test-001", "type": "SessionStart"}
```

- [ ] **Step 2: Write the session-start hook**

Create `hooks/session-start.sh`. The hook:

1. Runs `git fetch` in a detached background process (if git is available)
2. Checks for divergence (`git rev-list --count HEAD..@{u}`)
3. Checks for dirty tree (`git status --porcelain`)
4. Reads `SOUL.md` (first 100 lines)
5. Reads `config/active-preset.txt` → reads the preset file if set
6. Reads `config/session-state.md` if it exists, validates `schema_version`
7. Checks for available tools: `git`, `latexmk`/`pdflatex`, `sage`/`wolframscript`/`python3+sympy`, `lean`/`lake`, `curl`
8. Outputs JSON with `additionalContext` (persona + preset + state) and `systemMessage` (git status + capability report)

Each capability check is a simple `command -v <tool>` with fallback messaging.

- [ ] **Step 3: Write expected output fixture**

Create `tests/hooks/session-start/expected-clean-repo.json`:

```json
{
  "systemMessage": "Git: up to date with origin.\nCapabilities: git ✓, latexmk ?, sage ?, python3+sympy ?, lean ?, curl ?",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[SOUL.md persona content]\n---\n[Active preset content]\n---\n[Session state or 'No saved state']"
  }
}
```

(The `?` marks and exact content will vary by environment — this is a structural template. The test runner should validate JSON structure, not exact string matches.)

- [ ] **Step 4: Make executable and test manually**

```bash
chmod +x hooks/session-start.sh
echo '{"session_id":"test"}' | bash hooks/session-start.sh
```

Expected: Valid JSON with `systemMessage` and `hookSpecificOutput.additionalContext` keys.

- [ ] **Step 4: Commit**

```bash
git add hooks/session-start.sh tests/hooks/session-start/
git commit -m "feat: add session-start hook with capability detection"
```

---

## Task 6: LaTeX Validation Hook

**Files:**
- Create: `hooks/latex-validate.sh`
- Create: `config/latex-root.txt`
- Create: `tests/hooks/latex-validate/payload-tex-edit.json`
- Create: `tests/hooks/latex-validate/payload-non-tex-edit.json`

- [ ] **Step 1: Write test payloads**

`tests/hooks/latex-validate/payload-tex-edit.json`:
```json
{"tool_name": "Edit", "tool_input": {"file_path": "/path/to/main.tex"}}
```

`tests/hooks/latex-validate/payload-non-tex-edit.json`:
```json
{"tool_name": "Edit", "tool_input": {"file_path": "/path/to/script.py"}}
```

- [ ] **Step 2: Write the hook**

Create `hooks/latex-validate.sh`. The hook:

1. Reads JSON from stdin via `jq`
2. Extracts file path from `tool_input.file_path` or `tool_response.filePath`
3. Checks if file ends in `.tex` — if not, exit silently
4. Checks debounce: reads `/tmp/lots-last-compile` timestamp, skips if < 5s ago
5. Determines compile root: reads `config/latex-root.txt` if it exists, otherwise uses the edited file
6. Runs `latexmk -pdf -interaction=nonstopmode -halt-on-error -no-shell-escape` with 30s timeout
7. If fail: outputs JSON with `hookSpecificOutput.additionalContext` containing the error
8. If success or `latexmk` missing: silent exit

- [ ] **Step 3: Test with non-tex payload**

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.py"}}' | bash hooks/latex-validate.sh
```

Expected: No output (skipped).

- [ ] **Step 4: Commit**

```bash
git add hooks/latex-validate.sh config/latex-root.txt tests/hooks/latex-validate/
git commit -m "feat: add latex-validate hook with compile-root and debounce"
```

---

## Task 7: PreCompact Hook

**Files:**
- Create: `hooks/pre-compact.sh`
- Create: `tests/hooks/pre-compact/test-stale-warning.sh`

- [ ] **Step 1: Write the hook**

Create `hooks/pre-compact.sh`. The hook:

1. Checks if `config/session-state.md` exists
2. If missing: outputs JSON with `additionalContext` warning to run `/session-save`
3. If exists: parses YAML frontmatter, checks `session_id` against `$CLAUDE_CODE_SESSION` env var and `updated_at` against current time
4. If stale: outputs JSON with warning + injects the stale state as context anyway (better than nothing)
5. If fresh: injects state as `additionalContext`

- [ ] **Step 2: Write stale-state test**

Create `tests/hooks/pre-compact/test-stale-warning.sh`:

```bash
#!/bin/bash
set -e
cp tests/hooks/pre-compact/session-state-stale.md config/session-state.md
OUTPUT=$(echo '{"type":"PreCompact"}' | bash hooks/pre-compact.sh)
echo "$OUTPUT" | grep -q "not saved" && echo "PASS: stale warning" || echo "FAIL: no warning"
rm -f config/session-state.md
```

- [ ] **Step 3: Test**

Run: `bash tests/hooks/pre-compact/test-stale-warning.sh`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add hooks/pre-compact.sh tests/hooks/pre-compact/test-stale-warning.sh
git commit -m "feat: add pre-compact hook with stale state detection"
```

---

## Task 8: StatusLine Hook

**Files:**
- Create: `hooks/statusline.sh`
- Create: `tests/hooks/statusline/payload.json`
- Create: `tests/hooks/statusline/expected-output.txt`

- [ ] **Step 1: Write the hook**

Create `hooks/statusline.sh`. The hook:

1. Reads JSON from stdin (`session_id`, `model`, `context_window`)
2. Reads active preset name from `config/active-preset.txt` (or "general")
3. Reads current section + computation from `config/session-state.md` (or "—")
4. Computes context usage bar from `context_window` data (scaled to 80% of raw capacity)
5. Outputs ANSI-formatted string: `LOTS | <preset> | <section> | <computation> | [████░░ XX%]`

Color thresholds: green < 63%, yellow < 81%, orange < 95%, red >= 95%.

- [ ] **Step 2: Test with fixture**

```bash
echo '{"session_id":"test","model":"claude-opus-4-6","context_window":{"used":400000,"total":1000000}}' | bash hooks/statusline.sh
```

Expected: Formatted statusline string with "LOTS | triality | — | — | [████████░░ 50%]"

- [ ] **Step 3: Commit**

```bash
git add hooks/statusline.sh tests/hooks/statusline/
git commit -m "feat: add statusline hook with context bar"
```

---

## Task 9: Test Runner

**Files:**
- Create: `tests/run-tests.sh`

- [ ] **Step 1: Write the test runner**

Create `tests/run-tests.sh` that:

1. Creates a temporary working directory (`mktemp -d`) and copies `config/` into it to avoid polluting the real config during tests
2. Sets `LOTS_CONFIG_DIR` env var pointing to the temp dir (hooks should respect this if set)
3. Runs all preset tests (`tests/presets/*.sh`)
4. Runs all hook contract tests — pipes `tests/hooks/*/payload-*.json` into hooks, validates output structure via `jq` (check required keys exist), not exact string matching
5. Reports pass/fail count
6. Cleans up temp directory
7. Exits with non-zero if any test fails

**Test isolation:** Tests run sequentially. Each test that mutates config files (e.g., preset switching, session-state writing) operates in the temp directory. Tests should NOT modify files in the real `config/` directory.

**Aggregates test fixtures from:** Tasks 2 (presets), 5 (session-start), 6 (latex-validate), 7 (pre-compact), 8 (statusline).

- [ ] **Step 2: Run all tests**

Run: `bash tests/run-tests.sh`
Expected: All tests pass.

- [ ] **Step 3: Commit**

```bash
git add tests/run-tests.sh
git commit -m "feat: add unified test runner"
```

---

## Task 10: Domain Skill — fatgraph

**Files:**
- Create: `skills/fatgraph.md`

- [ ] **Step 1: Write the skill**

Create `skills/fatgraph.md` with:
- YAML frontmatter: `name: fatgraph`, `description: Generate TikZ ribbon graph for specified genus and edge structure`
- Process: Read `config/active-preset.txt`, apply preset if active. Generate TikZ code for a ribbon graph. If preset active, label edges with Strebel lengths and enforce perimeter constraints.
- The skill should produce compilable LaTeX that can be pasted directly into a document.
- Reference: MAPPING_DICTIONARY §I for Strebel graph structure.

- [ ] **Step 2: Commit**

```bash
git add skills/fatgraph.md
git commit -m "feat: add fatgraph skill for TikZ ribbon graph generation"
```

---

## Task 11: Domain Skill — topological-recursion

**Files:**
- Create: `skills/topological-recursion.md`

- [ ] **Step 1: Write the skill**

Create `skills/topological-recursion.md` with:
- Process: Read preset. Detect available symbolic engine (sage > wolframscript > sympy). Write a computation script for the Eynard-Orantin recursion $W^{(g)}_s$. Execute via Bash. Interpret result.
- Preset narrows to: Gaussian means spectral curve (Convention A: `xy - y^2 = 1`), recursion kernel from MAPPING_DICTIONARY §III.
- Include explicit corpus pointers: "Read MAPPING_DICTIONARY §III for kernel K(p,q) and Bergmann kernel B(p,q)."

- [ ] **Step 2: Commit**

```bash
git add skills/topological-recursion.md
git commit -m "feat: add topological-recursion skill"
```

---

## Task 12: Domain Skill — series-expand

**Files:**
- Create: `skills/series-expand.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Detect engine. Expand matrix model/field theory in specified parameter. Preset narrows to Kontsevich-Penner 1/N. Corpus pointers: MAPPING_DICTIONARY §IV.

- [ ] **Step 2: Commit**

```bash
git add skills/series-expand.md
git commit -m "feat: add series-expand skill"
```

---

## Task 13: Domain Skill — check-limits

**Files:**
- Create: `skills/check-limits.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Verify physics expression in specified limits/boundaries. Preset narrows to moduli space boundary divergences, Strebel degeneration. Corpus pointers: `2212.05999` §5.

- [ ] **Step 2: Commit**

```bash
git add skills/check-limits.md
git commit -m "feat: add check-limits skill"
```

---

## Task 14: Domain Skill — strebel-solver

**Files:**
- Create: `skills/strebel-solver.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Solve Strebel constraint system for given graph topology and perimeters. Enumerate valid metrized ribbon graphs. Preset narrows to genus-one torus with integer lengths and Belyi permutation handling. Corpus pointers: MAPPING_DICTIONARY §I-§II, `2212.05999` §5, `0803.2681`.

- [ ] **Step 2: Commit**

```bash
git add skills/strebel-solver.md
git commit -m "feat: add strebel-solver skill"
```

---

## Task 15: Domain Skill — discrete-volumes

**Files:**
- Create: `skills/discrete-volumes.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Compute discrete volumes $N_{g,s}(P_1,\ldots,P_s)$ via Norbury-style lattice-point recursion. Preset narrows to Giacchetto-Maity-Mazenc discrete Mirzakhani recursion from `2510.17728`. Corpus pointers: MAPPING_DICTIONARY §IV, `0801.4590`.

- [ ] **Step 2: Commit**

```bash
git add skills/discrete-volumes.md
git commit -m "feat: add discrete-volumes skill"
```

---

## Task 16: Domain Skill — formalize-lemma

**Files:**
- Create: `skills/formalize-lemma.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Take LaTeX equation, translate to Lean 4 theorem using mathlib4 conventions. Run `lake build`. Retry loop (max 5). Failure path: report best attempt + suggestions. Scope limited to combinatorial/algebraic shell (parity, Euler char, recursion identities), NOT analytic core.

- [ ] **Step 2: Commit**

```bash
git add skills/formalize-lemma.md
git commit -m "feat: add formalize-lemma skill"
```

---

## Task 17: Domain Skill — quiver

**Files:**
- Create: `skills/quiver.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Generate LaTeX quiver diagram using tikz-cd. Preset narrows to U(N) adjoint quivers for N=4 SYM subsectors.

- [ ] **Step 2: Commit**

```bash
git add skills/quiver.md
git commit -m "feat: add quiver skill"
```

---

## Task 18: Domain Skill — inspire-search

**Files:**
- Create: `skills/inspire-search.md`

- [ ] **Step 1: Write the skill**

Process: Read preset. Use WebFetch to query `inspirehep.net/api/literature?q=...`. Parse JSON. Return formatted results. Preset pre-filters to tensionless string / k=1 / topological recursion community.

- [ ] **Step 2: Commit**

```bash
git add skills/inspire-search.md
git commit -m "feat: add inspire-search skill"
```

---

## Task 19: Domain Skill — add-reference

**Files:**
- Create: `skills/add-reference.md`

- [ ] **Step 1: Write the skill**

Process: Takes arXiv ID. **Verifies** by fetching `arxiv.org/abs/[ID]` — displays title/authors for confirmation. Downloads via curl, extracts to `reference/source_tex/[ID]/`, standardizes main tex filename. Handles: multi-file tar, single gzip, PDF-only (warn). Validates: no path traversal in archive, no symlinks escaping target dir.

- [ ] **Step 2: Commit**

```bash
git add skills/add-reference.md
git commit -m "feat: add add-reference skill with arXiv ID verification"
```

---

## Task 20: README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write comprehensive README**

Sections (per spec §10):
- Installation (marketplace + local clone)
- Onboarding (Overleaf GitHub sync step-by-step, fallback for non-Premium, symbolic math engine setup, Lean 4 setup)
- Skills Reference (all 12 skills documented with examples)
- Preset System (how it works, editing, creating new presets, `/preset` command, recovery path)
- Corpus Management (what's in it, `add-reference`, MAPPING_DICTIONARY)
- Hooks (what each does, how to disable)
- Configuration (preset format, session-state format, permissions)
- Troubleshooting (LaTeX errors, engine detection, Lean failures, Overleaf conflicts, context exhaustion)

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add comprehensive README"
```

---

## Task 21: Onboarding Guide

**Files:**
- Create: `docs/onboarding.md`

- [ ] **Step 1: Write Overleaf GitHub sync guide**

Step-by-step for Edward:
1. Link GitHub account in Overleaf (Account Settings)
2. Create GitHub repo from Overleaf project
3. Clone locally
4. Point Claude Code at the repo
5. Verify: edit a file, commit, push, pull in Overleaf

Include fallback instructions for non-Premium users (download/upload manually).

- [ ] **Step 2: Commit**

```bash
git add docs/onboarding.md
git commit -m "docs: add Overleaf onboarding guide"
```

---

## Task 22: Final Integration Test

**Files:**
- Create: `tests/MANUAL_TESTS.md`

- [ ] **Step 1: Create manual test protocol document**

Create `tests/MANUAL_TESTS.md` documenting the smoke test protocol from spec §9.3:

```markdown
# Manual Smoke Tests

## Prerequisites
- Claude Code with Lord of the Strings plugin loaded
- A git repo with at least one .tex file

## Tests
1. Start session → verify SOUL.md persona appears in context
2. `/preset triality` → verify config/active-preset.txt contains path
3. `/fatgraph 3` → verify compilable TikZ output
4. `/inspire-search "tensionless string"` → verify results with arXiv links
5. `/session-save` → verify config/session-state.md has valid YAML frontmatter
6. `/preset null` → verify active-preset.txt is empty
```

- [ ] **Step 2: Run all automated tests**

```bash
bash tests/run-tests.sh
```

Expected: All pass.

- [ ] **Step 2: Manual smoke test**

Follow the manual test protocol from spec §9.3:
1. Start Claude Code session with plugin loaded → verify persona injection
2. Run `/preset triality` → verify `active-preset.txt` updated
3. Run `/fatgraph 3` → verify TikZ output
4. Run `/inspire-search "tensionless string"` → verify results
5. Run `/session-save` → verify `session-state.md` with valid YAML frontmatter
6. Run `/preset null` → verify general mode

- [ ] **Step 3: Final commit**

```bash
git add tests/MANUAL_TESTS.md
git commit -m "feat: Lord of the Strings v0.1.0 — complete plugin"
git tag v0.1.0
```
