# claude-harness

새 프로젝트에 Claude Code 하네스를 붙이기 위한 템플릿 모음.

## 설치 (한 번만)

```bash
./bootstrap.sh
```

Claude Code 개인 스킬로 등록됩니다. 이후 **아무 프로젝트에서** Claude Code를 열고:

```
/harness
```

"하네스 적용해줘"처럼 말해도 됩니다. Claude가 lockfile과 `package.json`을 읽어서 스택을 판단하고, 설치한 뒤 `프로젝트 정보`를 **실제 존재하는 명령으로** 맞춥니다.

레포를 옮기거나 `skill/SKILL.md.template`을 고쳤으면 `./bootstrap.sh`를 다시 실행하세요.

## 수동 사용

```bash
./install.sh ~/dev/my-project              # 기본형만
./install.sh ~/dev/my-project node-pnpm    # 스택 스니펫까지 적용
./install.sh --list                        # 스니펫 목록
```

스니펫을 지정하면 `CLAUDE.md`의 `# 프로젝트 정보` 블록이 그 스택 내용으로 채워집니다.
이미 있는 파일은 덮어쓰지 않습니다.

설치 후 할 일:

1. `CLAUDE.md`의 프로젝트 정보가 실제와 맞는지 확인 (스니펫 없이 설치했으면 직접 채우기)
2. `.claude/settings.json`의 `ask` 목록에서 안 쓰는 ORM 명령 지우기

`jq` 필요: `brew install jq`

## 구조

```
bootstrap.sh              /harness 스킬 등록 (한 번만)
install.sh                파일 복사 스크립트
skill/SKILL.md.template   /harness 스킬 본문
base/                     설치되는 것
├─ CLAUDE.md              Karpathy 4원칙 + 프로젝트 정보 블록 (40줄)
└─ .claude/
   ├─ settings.json       권한 deny/ask/allow
   └─ hooks/
      ├─ guard-bash.sh          파괴적 명령 + 패키지 매니저 혼용 차단
      └─ format-after-edit.sh   수정 파일만 포맷·린트

snippets/                 CLAUDE.md 프로젝트 정보 블록
├─ node-pnpm.md
└─ fastapi.md

docs/references.md        참고 자료 + 읽을 때 주의점
```

## 스니펫 추가

`snippets/<이름>.md`를 만들면 바로 `./install.sh <경로> <이름>`으로 쓸 수 있습니다.
형식은 기존 파일과 동일하게 `# 프로젝트 정보`로 시작하면 됩니다.

## 유지 방침

**CLAUDE.md에는 겪은 사고만 규칙으로 추가한다.** 미리 상상해서 쓴 규칙은 잡음이 되어 다른 규칙의 효과를 깎습니다. 한 줄 늘릴 때마다 "이게 왜 있는지 설명할 수 있나"를 확인.

**훅과 권한은 미리 채워도 된다.** 컨텍스트에 실리지 않아서 많아도 부작용이 없습니다.

프로젝트에서 유용했던 규칙은 `base/`나 `snippets/`로 역반영해서 다음 프로젝트가 물려받게 합니다.

`/harness` 스킬은 **규칙을 새로 발명하지 않도록** 지시받았습니다 — 템플릿을 설치하고 실제 값으로 맞추는 것까지만 합니다.
