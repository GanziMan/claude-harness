# claude-harness

새 프로젝트에 Claude Code 하네스(CLAUDE.md, 권한 설정, 훅)를 붙이기 위한 템플릿.

`/harness` 한 번으로 프로젝트 스택을 읽어서 맞춰 설치합니다.

## 요구사항

- macOS 또는 Linux (훅이 bash 스크립트입니다. Windows는 WSL 필요)
- `jq` — `brew install jq` / `apt install jq`
- Claude Code

## 시작

한 줄이면 됩니다.

```bash
git clone https://github.com/GanziMan/claude-harness.git ~/dev/claude-harness && ~/dev/claude-harness/bootstrap.sh
```

`bootstrap.sh`는 이 레포를 Claude Code **개인 스킬**로 등록합니다 (`~/.claude/skills/harness/`).
클론 위치는 자유이며, 스크립트가 그 경로를 기억합니다.

이후 **아무 프로젝트에서** Claude Code를 열고:

```
/harness
```

"하네스 적용해줘"처럼 말해도 됩니다. Claude가 lockfile과 `package.json`·`pyproject.toml`을 읽어서
스택과 패키지 매니저를 판단하고, 설치한 뒤 `프로젝트 정보`를 **실제 존재하는 명령으로** 맞춥니다.

레포를 옮기거나 `skill/SKILL.md.template`을 고쳤으면 `./bootstrap.sh`를 다시 실행하세요.

## 수동 사용 (스킬 없이)

```bash
./install.sh ~/dev/my-project              # 기본형만
./install.sh ~/dev/my-project node-pnpm    # 스택 스니펫까지 적용
./install.sh --list                        # 스니펫 목록
```

이미 있는 파일은 덮어쓰지 않습니다. 설치 후:

1. `CLAUDE.md`의 `# 프로젝트 정보` 블록을 실제 값으로 맞추기
2. `.claude/settings.json`의 `ask` 목록에서 안 쓰는 ORM 명령 지우기

## 구조

```
bootstrap.sh              /harness 스킬 등록 (한 번만)
install.sh                파일 복사 스크립트
skill/SKILL.md.template   /harness 스킬 본문

base/                     프로젝트에 설치되는 것
├─ CLAUDE.md              작업 원칙 4개 + 프로젝트 정보 블록 (40줄)
└─ .claude/
   ├─ settings.json       권한 deny / ask / allow
   └─ hooks/
      ├─ guard-bash.sh          파괴적 명령 + 패키지 매니저 혼용 차단
      └─ format-after-edit.sh   수정한 파일만 포맷·린트

snippets/                 CLAUDE.md 프로젝트 정보 블록
├─ node-pnpm.md
└─ fastapi.md

docs/references.md        참고 자료 + 읽을 때 주의점
```

## 무엇이 들어가나

**`CLAUDE.md`** — [Karpathy의 4원칙](https://aridanemartin.dev/blog/karpathy-4-lines-claude-md/)을 풀어 쓴 것. 40줄.

**`settings.json`**
- `deny` — `.env`·키 파일·`~/.ssh` 읽기, 마이그레이션·lockfile 직접 편집
- `ask` — push, commit, 마이그레이션 실행, `psql`
- `allow` — 테스트·린트·타입체크 등 읽기성 명령 (매번 승인 안 눌러도 됨)

`deny`/`ask`는 즉시 적용, `allow`는 폴더를 신뢰한 뒤부터 적용됩니다.

**`guard-bash.sh`** — force push, `reset --hard`, `git clean -f`, `prisma migrate reset`, `DROP TABLE`, `curl | sh` 차단. 그리고 **lockfile을 보고 그 프로젝트의 패키지 매니저를 판단해서 다른 매니저의 install 명령을 막습니다.**

**`format-after-edit.sh`** — 수정된 파일만 prettier/eslint 또는 ruff로 정리. 성공하면 침묵, 자동 수정이 안 되는 문제만 Claude에게 전달. 해당 도구가 없는 프로젝트에서는 조용히 넘어갑니다.

## 스니펫 추가

`snippets/<이름>.md`를 만들면 바로 `./install.sh <경로> <이름>`으로 쓸 수 있습니다.
`# 프로젝트 정보`로 시작하는 형식만 맞추면 됩니다.

들어있는 두 개는 **예시**입니다. 본인 스택에 맞게 고치거나 새로 만드세요.

## 유지 방침

**CLAUDE.md에는 겪은 사고만 규칙으로 추가한다.** 미리 상상해서 쓴 규칙은 잡음이 되어 다른 규칙의 효과를 깎습니다. 한 줄 늘릴 때마다 "이게 왜 있는지 설명할 수 있나"를 확인하세요.

**훅과 권한은 미리 채워도 된다.** 매 요청 컨텍스트에 실리지 않아서 많아도 부작용이 없습니다. 컨텍스트를 먹는 건 CLAUDE.md뿐입니다.

프로젝트에서 유용했던 규칙은 `base/`나 `snippets/`로 역반영해서 다음 프로젝트가 물려받게 합니다.

`/harness` 스킬은 **규칙을 새로 발명하지 않도록** 지시받았습니다 — 템플릿을 설치하고 실제 값으로 맞추는 것까지만 합니다.

## 왜 이렇게 만들었나

배경과 출처는 [`docs/references.md`](docs/references.md)에 정리해뒀습니다.

## 라이선스

MIT
