#!/usr/bin/env bash
# StatusLine hook — outputs a compact ANSI dashboard line.
# Reads JSON from stdin; outputs a single ANSI-formatted line (no newline at end).

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# ── 1. Read stdin JSON ──────────────────────────────────────────────────
input=$(cat)

# ── 2. Parse context_window ────────────────────────────────────────────
if command -v jq >/dev/null 2>&1; then
  ctx_used=$(printf '%s' "$input" | jq -r '.context_window.used // 0')
  ctx_total=$(printf '%s' "$input" | jq -r '.context_window.total // 1')
else
  ctx_used=$(printf '%s' "$input" | grep -o '"used":[0-9]*' | grep -o '[0-9]*' | head -1)
  ctx_total=$(printf '%s' "$input" | grep -o '"total":[0-9]*' | grep -o '[0-9]*' | head -1)
  ctx_used=${ctx_used:-0}
  ctx_total=${ctx_total:-1}
fi

# ── 3. Preset name ──────────────────────────────────────────────────────
preset_name="general"
preset_file="$REPO_ROOT/config/active-preset.txt"
if [ -f "$preset_file" ]; then
  preset_path=$(tr -d '[:space:]' < "$preset_file")
  if [ -n "$preset_path" ]; then
    preset_name=$(basename "$preset_path" | sed 's/\.[^.]*$//')
    [ -z "$preset_name" ] && preset_name="general"
  fi
fi

# ── 4. Current work & computation from session-state.md ────────────────
current_work="—"
computation="—"
state_file="$REPO_ROOT/config/session-state.md"
if [ -f "$state_file" ]; then
  # Extract first non-empty line after "## Current Work"
  current_work=$(awk '
    /^## Current Work/ { found=1; next }
    found && /^##/ { exit }
    found && /[^[:space:]]/ { print; exit }
  ' "$state_file")
  [ -z "$current_work" ] && current_work="—"

  # Extract Computation: line value
  computation=$(grep -m1 '^Computation:' "$state_file" | sed 's/^Computation:[[:space:]]*//')
  [ -z "$computation" ] && computation="—"
fi

# ── 5. Compute percentage (scaled to 80% of raw capacity) ──────────────
# pct = (used / (total * 0.8)) * 100
# Integer arithmetic: (used * 100 * 10) / (total * 8) gives pct*10; divide by 10 for rounding
# But simpler: (used * 100) / (total * 8 / 10) — however to avoid float, multiply numerator by 10:
# pct = (used * 1000) / (total * 8) gives the percentage directly (not tenths)
# Verification: 400000 * 1000 / (1000000 * 8) = 400000000/8000000 = 50 ✓
pct_display=$(( (ctx_used * 1000) / (ctx_total * 8) ))
[ $pct_display -gt 100 ] && pct_display=100

# ── 6. Build bar (10 blocks) ────────────────────────────────────────────
filled=$(( pct_display / 10 ))
empty=$(( 10 - filled ))
bar=""
i=0
while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
i=0
while [ $i -lt $empty ]; do bar="${bar}░"; i=$(( i + 1 )); done

# ── 7. Choose color ─────────────────────────────────────────────────────
if   [ $pct_display -lt 63 ]; then color="\033[32m"       # green
elif [ $pct_display -lt 81 ]; then color="\033[33m"       # yellow
elif [ $pct_display -lt 95 ]; then color="\033[38;5;208m" # orange
else                                color="\033[31m"       # red
fi
reset="\033[0m"

# ── 8. Emit line ────────────────────────────────────────────────────────
printf "${color}LOTS${reset} | ${preset_name} | ${current_work} | ${computation} | [${color}${bar} ${pct_display}%%${reset}]\n"
