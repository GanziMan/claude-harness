#!/usr/bin/env bash
# PreToolUse(Bash) 가드
# 1) 되돌릴 수 없는 명령 차단
# 2) 프로젝트 lockfile과 다른 패키지 매니저 사용 차단
set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
cwd=$(printf '%s' "$input" | jq -r '.cwd // "."')

deny() {
  jq -n --arg r "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $r
    }
  }'
  exit 0
}

# --- 1. 파괴적 명령 ---------------------------------------------------------
case "$cmd" in
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -fr /"*)
    deny "루트/홈 삭제는 차단됩니다." ;;
  *"git push --force"*|*"git push -f"*)
    deny "force push는 차단됩니다. --force-with-lease를 쓰거나 직접 실행하세요." ;;
  *"git reset --hard"*)
    deny "git reset --hard는 커밋되지 않은 변경을 지웁니다. 직접 실행하세요." ;;
  *"git clean -"*f*)
    deny "git clean -f는 추적되지 않은 파일을 지웁니다. 직접 실행하세요." ;;
  *"git checkout ."*|*"git restore ."*)
    deny "작업 트리 전체 되돌리기는 차단됩니다. 파일을 명시하세요." ;;
  *"prisma migrate reset"*|*"prisma db push --force"*|*"drizzle-kit drop"*)
    deny "DB를 초기화하는 명령입니다. 직접 실행하세요." ;;
  *"DROP TABLE"*|*"DROP DATABASE"*|*"TRUNCATE "*)
    deny "파괴적 SQL입니다. 직접 실행하세요." ;;
  *"chmod -R 777"*)
    deny "chmod -R 777은 차단됩니다." ;;
  *"curl "*"| sh"*|*"curl "*"| bash"*|*"wget "*"| sh"*)
    deny "원격 스크립트를 바로 실행하는 것은 차단됩니다." ;;
esac

# --- 2. 패키지 매니저 혼용 --------------------------------------------------
# lockfile이 있는 매니저만 허용한다. npm/pnpm/yarn 섞으면 lockfile이 깨진다.
mgr=""
if   [ -f "$cwd/pnpm-lock.yaml" ];     then mgr="pnpm"
elif [ -f "$cwd/yarn.lock" ];          then mgr="yarn"
elif [ -f "$cwd/package-lock.json" ];  then mgr="npm"
fi

if [ -n "$mgr" ]; then
  for other in pnpm yarn npm; do
    [ "$other" = "$mgr" ] && continue
    # "npm install", "yarn add" 처럼 매니저를 직접 호출하는 경우만 본다.
    if printf '%s' "$cmd" | grep -Eq "(^|[;&|] *)$other +(i|install|add|remove|rm|up|update|ci) "; then
      deny "이 프로젝트는 $mgr 을 씁니다(lockfile 기준). '$other' 명령은 lockfile을 깨뜨립니다."
    fi
  done
fi

exit 0
