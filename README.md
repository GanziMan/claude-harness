# claude-harness

새 프로젝트에 Claude Code 하네스를 붙이기 위한 템플릿 모음.

## 사용

```bash
./install.sh ~/dev/my-project
```

이미 있는 파일은 덮어쓰지 않습니다. 설치 후:

1. `CLAUDE.md`의 `# 프로젝트 정보` 블록을 채운다 → `snippets/`에 예시
2. `.claude/settings.json`의 `ask` 목록에서 안 쓰는 ORM 명령을 지운다

`jq` 필요: `brew install jq`

## 구조

```
base/                     설치되는 것
├─ CLAUDE.md              Karpathy 4원칙 + 프로젝트 정보 블록 (40줄)
└─ .claude/
   ├─ settings.json       권한 deny/ask/allow
   └─ hooks/
      ├─ guard-bash.sh          파괴적 명령 + 패키지 매니저 혼용 차단
      └─ format-after-edit.sh   수정 파일만 포맷·린트

snippets/                 CLAUDE.md 프로젝트 정보 블록 예시
├─ node-pnpm.md
└─ fastapi.md

docs/references.md        참고 자료 + 읽을 때 주의점
```

## 유지 방침

**CLAUDE.md에는 겪은 사고만 규칙으로 추가한다.** 미리 상상해서 쓴 규칙은 잡음이 되어 다른 규칙의 효과를 깎습니다. 한 줄 늘릴 때마다 "이게 왜 있는지 설명할 수 있나"를 확인.

**훅과 권한은 미리 채워도 된다.** 컨텍스트에 실리지 않아서 많아도 부작용이 없습니다.

프로젝트에서 유용했던 규칙은 `base/`로 역반영해서 다음 프로젝트가 물려받게 합니다.
