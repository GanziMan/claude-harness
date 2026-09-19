#!/usr/bin/env bash
# 대상 프로젝트에 하네스 기본형을 설치한다.
#   ./install.sh ~/dev/my-project
# 이미 있는 파일은 건드리지 않는다(덮어쓰지 않음).
set -euo pipefail

target="${1:-}"
if [ -z "$target" ]; then
  echo "사용법: ./install.sh <프로젝트 경로>" >&2
  exit 1
fi
[ -d "$target" ] || { echo "경로가 없습니다: $target" >&2; exit 1; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

command -v jq >/dev/null 2>&1 || echo "주의: jq가 필요합니다 → brew install jq"

cat <<MSG

완료. 다음 할 일:
  1. $target/CLAUDE.md 의 '프로젝트 정보' 블록 채우기
     → snippets/ 에 스택별 예시가 있습니다
  2. .claude/settings.json 의 ask 목록에서 안 쓰는 ORM 명령 지우기
MSG
