# Manual Smoke Tests

## Prerequisites

- Claude Code with the Lord of the Strings plugin loaded
- A git repo with at least one `.tex` file
- (Optional) SageMath or sympy installed for computation skills
- (Optional) Internet access for InspireHEP searches

---

## Tests

### 1. Session Start -- Persona Injection

**Action:** Start a new Claude Code session in the plugin directory.

**Verify:**
- `SOUL.md` persona appears in context
- Look for "Third Collaborator" or "k=1" in the initial system context
- Statusline shows `LOTS | ...`

### 2. Preset Activation

**Action:** Run `/preset triality`

**Verify:**
- `config/active-preset.txt` contains `config/presets/triality.md`
- Subsequent skill invocations respect triality conventions

### 3. Fatgraph Generation

**Action:** Run `/fatgraph 3`

**Verify:**
- Output contains compilable TikZ code
- Code compiles without errors when inserted into a LaTeX document with `\usepackage{tikz}`

### 4. InspireHEP Search

**Action:** Run `/inspire-search "tensionless string"`

**Verify:**
- Results returned with arXiv links
- At least one result relates to tensionless strings

### 5. Session Save

**Action:** Run `/session-save`

**Verify:**
- `config/session-state.md` is created (or updated)
- File contains valid YAML frontmatter with `schema_version: 1`
- Research context (current section, open questions, etc.) is captured

### 6. Preset Clear

**Action:** Run `/preset null`

**Verify:**
- `config/active-preset.txt` is empty (zero bytes or whitespace only)
- Skills revert to general-mode behavior

### 7. Statusline Display

**Action:** Observe the Claude Code statusline during any session.

**Verify:**
- Format: `LOTS | <preset> | <section> | <engine> | [context bar]`
- Updates when preset changes or computation engine is used

---

## Expected Behavior

- All 12 skills should load without errors
- Preset switching should be immediate (no restart required)
- Session state should persist across context compaction (PreCompact hook reinjects it)
- LaTeX validation hook should fire after any `.tex` file edit
- StatusLine should update in real time as session state changes

---

## Failure Recovery

If a test fails:

1. Check that all files in `skills/`, `hooks/`, and `config/` are present and readable
2. Run `bash tests/run-tests.sh` for automated hook/preset checks
3. Verify `config/active-preset.txt` and `config/latex-root.txt` exist
4. Check Claude Code logs for hook execution errors
