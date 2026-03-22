#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Setup: copy stale fixture to temp config dir
mkdir -p "$TMPDIR/config"
cp "$REPO_ROOT/tests/hooks/pre-compact/session-state-stale.md" "$TMPDIR/config/session-state.md"

# Run hook from the temp dir so it finds config/session-state.md
OUTPUT=$(cd "$TMPDIR" && echo '{"type":"PreCompact"}' | bash "$REPO_ROOT/hooks/pre-compact.sh" 2>/dev/null)

# Check for warning
if echo "$OUTPUT" | grep -q "previous session"; then
    echo "PASS: stale warning detected"
else
    echo "FAIL: no stale warning in output"
    echo "Output was: $OUTPUT"
    exit 1
fi
