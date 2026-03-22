#!/bin/bash
# Unified test runner for Lord of the Strings

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

# Setup temp dir and copy config into it
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT
cp -r "$REPO_ROOT/config" "$TMPDIR/config"
export LOTS_CONFIG_DIR="$TMPDIR/config"

# Run from repo root so relative paths in hooks/scripts work
cd "$REPO_ROOT"

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

# --- Test 1: Preset switching ---
if bash tests/presets/test-preset-switch.sh > /dev/null 2>&1; then
    pass "preset switching"
else
    fail "preset switching"
fi

# --- Test 2: Session-start hook (valid JSON with required keys) ---
OUTPUT=$(bash hooks/session-start.sh \
    < tests/hooks/session-start/payload-clean-repo.json 2>/dev/null)
if echo "$OUTPUT" | jq -e 'has("systemMessage") and has("hookSpecificOutput")' \
    > /dev/null 2>&1; then
    pass "session-start hook (valid JSON with required keys)"
else
    fail "session-start hook (valid JSON with required keys)"
fi

# --- Test 3: LaTeX-validate hook skip (non-.tex file → no output) ---
OUTPUT=$(bash hooks/latex-validate.sh \
    < tests/hooks/latex-validate/payload-non-tex-edit.json 2>/dev/null)
if [ -z "$OUTPUT" ]; then
    pass "latex-validate hook (skip non-.tex file)"
else
    fail "latex-validate hook (skip non-.tex file — expected empty stdout)"
fi

# --- Test 4: Pre-compact hook (stale warning) ---
if bash tests/hooks/pre-compact/test-stale-warning.sh > /dev/null 2>&1; then
    pass "pre-compact hook (stale warning)"
else
    fail "pre-compact hook (stale warning)"
fi

# --- Test 5: Statusline hook (output contains LOTS) ---
OUTPUT=$(bash hooks/statusline.sh \
    < tests/hooks/statusline/payload.json 2>/dev/null)
if echo "$OUTPUT" | grep -q "LOTS"; then
    pass "statusline hook (output contains LOTS)"
else
    fail "statusline hook (output contains LOTS)"
fi

# --- Summary ---
echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
