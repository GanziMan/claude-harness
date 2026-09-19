#!/usr/bin/env bash
# 이 레포를 Claude Code 개인 스킬로 등록한다.
# 등록하면 어느 프로젝트에서든 /harness 로 하네스를 설치할 수 있다.
#
#   ./bootstrap.sh
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest="$HOME/.claude/skills/harness"

mkdir -p "$dest"
sed "s|__HARNESS_REPO__|$here|g" "$here/skill/SKILL.md.template" > "$dest/SKILL.md"

echo "등록: $dest/SKILL.md"
echo "템플릿 경로: $here"
echo
echo "이제 아무 프로젝트에서 Claude Code를 열고 /harness 라고 하면 됩니다."
echo "('하네스 적용해줘' 처럼 말해도 Claude가 알아서 씁니다)"
echo
echo "레포를 옮기거나 SKILL.md.template을 고쳤으면 이 스크립트를 다시 실행하세요."
