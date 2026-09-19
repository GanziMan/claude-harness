#!/usr/bin/env bash
# PostToolUse(Edit|Write) — 수정된 파일만 포맷/린트한다.
# 성공하면 아무 말도 하지 않고, 실패했을 때만 Claude에게 알린다.
set -uo pipefail

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // ""')
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

root=$(printf '%s' "$input" | jq -r '.cwd // "."')
bin="$root/node_modules/.bin"
out=""

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.json|*.css|*.md)
    [ -x "$bin/prettier" ] && out+=$("$bin/prettier" --write "$file" 2>&1 >/dev/null)
    case "$file" in
      *.ts|*.tsx|*.js|*.jsx)
        [ -x "$bin/eslint" ] && out+=$("$bin/eslint" --fix "$file" 2>&1)
        ;;
    esac
    ;;
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      out+=$(ruff format "$file" 2>&1 >/dev/null)
      out+=$(ruff check --fix "$file" 2>&1)
    fi
    ;;
esac

# 자동 수정으로 해결되지 않은 문제만 보고한다.
if [ -n "${out// /}" ]; then
  jq -n --arg m "$out" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: ("남은 린트 문제:\n" + $m)
    }
  }'
fi

exit 0
