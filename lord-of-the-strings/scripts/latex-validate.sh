#!/usr/bin/env bash
# PostToolUse hook — validates LaTeX files by compiling them after edits.
# Triggered on Edit|Write. Reads JSON payload from stdin.
set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
DEBOUNCE_FILE="/tmp/lots-last-compile"
DEBOUNCE_SECS=5

# ── 1. Parse stdin ──────────────────────────────────────────────────────────
payload=$(cat)

if command -v jq >/dev/null 2>&1; then
  file_path=$(printf '%s' "$payload" | jq -r '
    .tool_input.file_path // .tool_response.filePath // empty' 2>/dev/null || true)
else
  file_path=$(printf '%s' "$payload" \
    | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 \
    | sed 's/.*:[[:space:]]*"\(.*\)"/\1/' || true)
fi

# ── 2. Only act on .tex files ───────────────────────────────────────────────
[[ -z "$file_path" ]] && exit 0
[[ "$file_path" != *.tex ]] && exit 0

# ── 3. Debounce ─────────────────────────────────────────────────────────────
now=$(date +%s)
if [ -f "$DEBOUNCE_FILE" ]; then
  last=$(cat "$DEBOUNCE_FILE" 2>/dev/null || echo 0)
  elapsed=$(( now - last ))
  [ "$elapsed" -lt "$DEBOUNCE_SECS" ] && exit 0
fi
printf '%s' "$now" > "$DEBOUNCE_FILE"

# ── 4. Determine compile target ─────────────────────────────────────────────
compile_target="$file_path"
root_cfg="$PLUGIN_ROOT/config/latex-root.txt"
if [ -f "$root_cfg" ]; then
  root_val=$(tr -d '[:space:]' < "$root_cfg")
  [ -n "$root_val" ] && compile_target="$root_val"
fi

# ── 5. Find LaTeX compiler ──────────────────────────────────────────────────
compiler=""
compiler_args=()
if command -v latexmk >/dev/null 2>&1; then
  compiler="latexmk"
  compiler_args=(-pdf -interaction=nonstopmode -halt-on-error -no-shell-escape)
elif command -v pdflatex >/dev/null 2>&1; then
  compiler="pdflatex"
  compiler_args=(-interaction=nonstopmode -halt-on-error -no-shell-escape)
else
  exit 0  # graceful degradation — no compiler available
fi

# ── 6. Compile ───────────────────────────────────────────────────────────────
compile_dir="$(dirname "$compile_target")"
compile_file="$(basename "$compile_target")"
if command -v gtimeout >/dev/null 2>&1; then
    TIMEOUT_CMD="gtimeout 30"
elif command -v timeout >/dev/null 2>&1; then
    TIMEOUT_CMD="timeout 30"
else
    TIMEOUT_CMD=""
fi
compile_output=$(cd "$compile_dir" && $TIMEOUT_CMD "$compiler" "${compiler_args[@]}" "$compile_file" 2>&1) \
  && compile_exit=0 || compile_exit=$?

# ── 7. Report failures only ─────────────────────────────────────────────────
[ "$compile_exit" -eq 0 ] && exit 0

error_summary=$(printf '%s' "$compile_output" | grep -E "^!" | head -5 || true)
[ -z "$error_summary" ] && error_summary=$(printf '%s' "$compile_output" | tail -10)

context="LaTeX compile failed for \`${compile_target}\`:\n${error_summary}"

if command -v jq >/dev/null 2>&1; then
  jq -n \
    --arg sm "LaTeX compile error — see context for details." \
    --arg ac "$context" \
    '{systemMessage:$sm,hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$ac}}'
else
  sm_esc="${context//\"/\\\"}"
  sm_esc="${sm_esc//$'\n'/\\n}"
  printf '{"systemMessage":"LaTeX compile error \u2014 see context for details.","hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$sm_esc"
fi
