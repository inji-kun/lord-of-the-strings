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
