#!/usr/bin/env bash
# 대상 프로젝트에 하네스 기본형을 설치한다.
#
#   ./install.sh ~/dev/my-project                  기본형만
#   ./install.sh ~/dev/my-project node-pnpm        스니펫까지 적용
#   ./install.sh --list                            스니펫 목록
#
# 이미 있는 파일은 덮어쓰지 않는다.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

list_snippets() {
  echo "사용 가능한 스니펫:"
  for f in "$here"/snippets/*.md; do
    [ -e "$f" ] || { echo "  (없음)"; return; }
    echo "  - $(basename "$f" .md)"
  done
}

if [ "${1:-}" = "--list" ]; then
  list_snippets
  exit 0
fi

target="${1:-}"
snippet="${2:-}"

if [ -z "$target" ]; then
  cat >&2 <<USAGE
사용법:
  ./install.sh <프로젝트 경로> [스니펫 이름]
  ./install.sh --list
USAGE
  exit 1
fi
[ -d "$target" ] || { echo "경로가 없습니다: $target" >&2; exit 1; }

snippet_file=""
if [ -n "$snippet" ]; then
  snippet_file="$here/snippets/$snippet.md"
  if [ ! -f "$snippet_file" ]; then
    echo "그런 스니펫이 없습니다: $snippet" >&2
    list_snippets >&2
    exit 1
  fi
fi

copy() { # src dst
  if [ -e "$2" ]; then
    echo "건너뜀 (이미 있음): ${2#$target/}"
  else
    mkdir -p "$(dirname "$2")"
    cp "$1" "$2"
    echo "생성: ${2#$target/}"
  fi
}

copy "$here/base/CLAUDE.md"                            "$target/CLAUDE.md"
copy "$here/base/.claude/settings.json"                "$target/.claude/settings.json"
copy "$here/base/.claude/hooks/guard-bash.sh"          "$target/.claude/hooks/guard-bash.sh"
copy "$here/base/.claude/hooks/format-after-edit.sh"   "$target/.claude/hooks/format-after-edit.sh"

chmod +x "$target"/.claude/hooks/*.sh 2>/dev/null || true

# --- 스니펫 적용: CLAUDE.md의 '# 프로젝트 정보' 블록을 교체한다 --------------
snippet_applied=0
if [ -n "$snippet_file" ]; then
  claude_md="$target/CLAUDE.md"
  if grep -q '^# 프로젝트 정보' "$claude_md" && grep -q '^# 금지' "$claude_md"; then
    tmp="$(mktemp)"
    # 블록 앞부분
    sed '/^# 프로젝트 정보/,$d' "$claude_md" > "$tmp"
    # 스니펫 본문 (주석 줄 제외)
    grep -v '^<!--' "$snippet_file" | sed '/./,$!d' >> "$tmp"
    printf '\n' >> "$tmp"
    # '# 금지' 이후
    sed -n '/^# 금지/,$p' "$claude_md" >> "$tmp"
    mv "$tmp" "$claude_md"
    echo "적용: CLAUDE.md 프로젝트 정보 블록 ← snippets/$snippet.md"
    snippet_applied=1
  else
    echo "주의: CLAUDE.md에서 '# 프로젝트 정보' 블록을 찾지 못해 스니펫을 적용하지 않았습니다." >&2
  fi
fi

command -v jq >/dev/null 2>&1 || echo "주의: jq가 필요합니다 → brew install jq"

echo
echo "완료. 다음 할 일:"
if [ "$snippet_applied" = "1" ]; then
  echo "  1. CLAUDE.md의 프로젝트 정보가 실제와 맞는지 확인"
else
  echo "  1. CLAUDE.md의 '프로젝트 정보' 블록 채우기 (./install.sh --list 로 스니펫 확인)"
fi
echo "  2. .claude/settings.json의 ask 목록에서 안 쓰는 ORM 명령 지우기"
