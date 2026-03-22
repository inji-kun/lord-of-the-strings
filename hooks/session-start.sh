#!/usr/bin/env bash
# SessionStart hook — loads persona, preset, session state, and detects capabilities.
# Reads stdin (JSON payload) but does not parse it.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# ── 1. Background git fetch & divergence check ──────────────────────────
git_status_msg=""
if command -v git >/dev/null 2>&1 && git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Fire-and-forget fetch (never block)
  git -C "$REPO_ROOT" fetch --quiet 2>/dev/null &
  disown 2>/dev/null || true

  behind=$(git -C "$REPO_ROOT" rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
  dirty=$(git -C "$REPO_ROOT" status --porcelain 2>/dev/null | head -c1)

  if [ "$behind" -gt 0 ] 2>/dev/null; then
    git_status_msg="behind upstream by ${behind} commit(s)"
  fi
  if [ -n "$dirty" ]; then
    [ -n "$git_status_msg" ] && git_status_msg="${git_status_msg}; "
    git_status_msg="${git_status_msg}working tree dirty"
  fi
  [ -z "$git_status_msg" ] && git_status_msg="repo clean, up to date"
  git_status_msg="git: ${git_status_msg}"
else
  git_status_msg="git: not available"
fi

# ── 2. Read persona (SOUL.md) ───────────────────────────────────────────
soul=""
if [ -f "$REPO_ROOT/SOUL.md" ]; then
  soul=$(cat "$REPO_ROOT/SOUL.md")
fi

# ── 3. Read active preset ───────────────────────────────────────────────
preset=""
preset_file="$REPO_ROOT/config/active-preset.txt"
if [ -f "$preset_file" ]; then
  preset_path=$(cat "$preset_file" | tr -d '[:space:]')
  if [ -n "$preset_path" ] && [ -f "$REPO_ROOT/$preset_path" ]; then
    preset=$(cat "$REPO_ROOT/$preset_path")
  elif [ -n "$preset_path" ] && [ -f "$preset_path" ]; then
    preset=$(cat "$preset_path")
  fi
fi

# ── 4. Read session state ───────────────────────────────────────────────
session_state=""
state_file="$REPO_ROOT/config/session-state.md"
if [ -f "$state_file" ]; then
  content=$(cat "$state_file")
  # Parse schema_version from YAML frontmatter
  schema_ver=$(echo "$content" | sed -n '/^---$/,/^---$/p' | grep -E '^schema_version:' | head -1 | awk '{print $2}' || true)
  if [ "$schema_ver" = "1" ]; then
    session_state="$content"
  elif [ -n "$schema_ver" ]; then
    session_state="[WARNING: session-state schema_version=$schema_ver, expected 1]"
  else
    # No frontmatter or no schema_version — include as-is
    session_state="$content"
  fi
fi

# ── 5. Capability detection ─────────────────────────────────────────────
caps=""
check_cap() {
  local name="$1"; shift
  if "$@" >/dev/null 2>&1; then
    caps="${caps}${name} ✓  "
  else
    caps="${caps}${name} ✗  "
  fi
}

check_cap "git"           command -v git
check_cap "latex"         sh -c "command -v latexmk || command -v pdflatex"
check_cap "sage"          command -v sage
check_cap "wolframscript" command -v wolframscript
check_cap "sympy"         python3 -c "import sympy"
check_cap "lean/lake"     command -v lake
check_cap "curl"          command -v curl
check_cap "jq"            command -v jq

caps=$(echo "$caps" | sed 's/  $//')

# ── 6. Build system message ─────────────────────────────────────────────
system_msg="${git_status_msg} | capabilities: ${caps}"

# ── 7. Build additional context ─────────────────────────────────────────
additional=""
if [ -n "$soul" ]; then
  additional="=== SOUL.md ===
${soul}"
fi
if [ -n "$preset" ]; then
  additional="${additional}

=== Active Preset ===
${preset}"
fi
if [ -n "$session_state" ]; then
  additional="${additional}

=== Session State ===
${session_state}"
fi

# ── 8. Output JSON ──────────────────────────────────────────────────────
if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg sm "$system_msg" \
    --arg ac "$additional" \
    '{
      systemMessage: $sm,
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext: $ac
      }
    }'
else
  # Manual JSON with escaping
  escape_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\t'/\\t}"
    s="${s//$'\r'/\\r}"
    printf '%s' "$s"
  }
  sm_esc=$(escape_json "$system_msg")
  ac_esc=$(escape_json "$additional")
  cat <<ENDJSON
{"systemMessage":"${sm_esc}","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"${ac_esc}"}}
ENDJSON
fi
