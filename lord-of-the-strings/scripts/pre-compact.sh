#!/bin/bash
# pre-compact.sh — PreCompact hook: inject session state into context before compaction
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
STATE_FILE="$PLUGIN_ROOT/config/session-state.md"

emit_json() {
  local system_msg="$1"
  local additional_ctx="$2"

  if command -v jq &>/dev/null; then
    jq -n \
      --arg sm "$system_msg" \
      --arg ac "$additional_ctx" \
      '{"systemMessage":$sm,"hookSpecificOutput":{"hookEventName":"PreCompact","additionalContext":$ac}}'
  else
    # Manual fallback — escape double quotes in context
    local escaped_ctx
    escaped_ctx=$(printf '%s' "$additional_ctx" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
    local escaped_sm
    escaped_sm=$(printf '%s' "$system_msg" | sed 's/"/\\"/g')
    printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"PreCompact","additionalContext":"%s"}}\n' \
      "$escaped_sm" "$escaped_ctx"
  fi
}

# --- Case 1: file missing ---
if [ ! -f "$STATE_FILE" ]; then
  emit_json "" "Research state not saved this session. Consider running /session-save to preserve your progress."
  exit 0
fi

# --- Case 2: file exists — parse frontmatter ---
FILE_CONTENTS=$(cat "$STATE_FILE")

# Extract fields from YAML frontmatter
SESSION_ID=$(printf '%s' "$FILE_CONTENTS" | awk '/^---/{f++; next} f==1 && /^session_id:/{gsub(/^session_id:[[:space:]]*/,""); print; exit}')
UPDATED_AT=$(printf '%s' "$FILE_CONTENTS" | awk '/^---/{f++; next} f==1 && /^updated_at:/{gsub(/^updated_at:[[:space:]]*/,""); gsub(/"/,""); print; exit}')

STALE=false

# Check session ID mismatch
if [ -n "${CLAUDE_CODE_SESSION:-}" ] && [ -n "$SESSION_ID" ] && [ "$SESSION_ID" != "$CLAUDE_CODE_SESSION" ]; then
  STALE=true
fi

# Check staleness: compare updated_at to now (2-hour threshold)
if [ -n "$UPDATED_AT" ]; then
  if command -v date &>/dev/null; then
    FILE_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$UPDATED_AT" "+%s" 2>/dev/null || date -d "$UPDATED_AT" "+%s" 2>/dev/null || echo 0)
    NOW_EPOCH=$(date "+%s")
    AGE=$(( NOW_EPOCH - FILE_EPOCH ))
    if [ "$AGE" -gt 7200 ]; then
      STALE=true
    fi
  fi
fi

if [ "$STALE" = true ]; then
  emit_json "Warning: session state is from a previous session" "$FILE_CONTENTS"
else
  emit_json "" "$FILE_CONTENTS"
fi
