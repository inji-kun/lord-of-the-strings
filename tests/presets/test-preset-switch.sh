#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Copy config structure to temp dir
cp -r "$REPO_ROOT/config" "$TMPDIR/config"

# Test 1: Write preset path
echo "config/presets/triality.md" > "$TMPDIR/config/active-preset.txt"
CONTENT=$(cat "$TMPDIR/config/active-preset.txt")
[ "$CONTENT" = "config/presets/triality.md" ] || { echo "FAIL: preset write"; exit 1; }

# Test 2: Clear preset (general mode)
> "$TMPDIR/config/active-preset.txt"
[ ! -s "$TMPDIR/config/active-preset.txt" ] || { echo "FAIL: preset clear"; exit 1; }

# Test 3: Preset file exists and is readable
[ -f "$TMPDIR/config/presets/triality.md" ] || { echo "FAIL: triality.md missing"; exit 1; }

echo "PASS: all preset tests"
