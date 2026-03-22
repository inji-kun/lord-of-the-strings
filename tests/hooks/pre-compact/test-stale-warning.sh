#!/bin/bash
set -e
# Setup: copy stale fixture to config
mkdir -p config
cp tests/hooks/pre-compact/session-state-stale.md config/session-state.md

# Run hook
OUTPUT=$(echo '{"type":"PreCompact"}' | bash hooks/pre-compact.sh 2>/dev/null)

# Check for warning
if echo "$OUTPUT" | grep -q "previous session"; then
    echo "PASS: stale warning detected"
else
    echo "FAIL: no stale warning in output"
    echo "Output was: $OUTPUT"
    exit 1
fi

# Cleanup
rm -f config/session-state.md
