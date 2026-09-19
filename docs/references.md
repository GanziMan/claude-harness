# 참고 자료

날짜는 확인한 발행일. 2026-09 기준.

## 개념

- [The Anatomy of an Agent Harness](https://www.langchain.com/blog/the-anatomy-of-an-agent-harness) — LangChain. 하네스 구성 요소 정리. `Agent = Model + Harness`
- [The importance of Agent Harness in 2026](https://www.philschmid.de/agent-harness-2026) (2026-01-05) — 모델=CPU, 컨텍스트=RAM, 하네스=OS 비유. 설계 원칙 3개
- [What is an Agent Harness](https://www.firecrawl.dev/blog/what-is-an-agent-harness) — 루프·툴 레이어·컨텍스트 압축의 실제 동작
- [AI harness economics](https://thenewstack.io/ai-agent-harness-economics/) (2026-09-19) — 추론 비용 하락(8월 -23.2%), 복잡 태스크 성공률 40% 미만 → 모델보다 하네스에 투자

## 실무 방법론

- [Harness engineering for coding agent users](https://martinfowler.com/articles/harness-engineering.html) — Guides(사전) / Sensors(사후) 프레임. 계산형 vs 추론형 센서 배치
- [Agent Harness Engineering](https://addyosmani.com/blog/agent-harness-engineering/) — Ratchet 방식. "실패를 영구 규칙으로 전환". AGENTS.md 60줄 이내
- [Harness engineering: leveraging Codex](https://openai.com/index/harness-engineering/) (2026-02-11) — OpenAI 공식. 레포를 system of record로, 린터로 불변식 강제, 백그라운드 부채 정리

## CLAUDE.md 규칙

- [Karpathy의 4줄](https://aridanemartin.dev/blog/karpathy-4-lines-claude-md/) (원문 2026-04) — Think Before Coding / Simplicity First / Surgical Changes / Goal-Driven Execution. `base/CLAUDE.md`가 이걸 풀어 쓴 것
- [awesome-claude-md](https://github.com/josix/awesome-claude-md) — 공개 레포의 실제 CLAUDE.md 사례 분석
- [claude-md-templates](https://github.com/abhishekray07/claude-md-templates) — 스택별 템플릿

## 모음집

- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) (53.1k stars) — 훅, 슬래시 커맨드, 스킬. 훅 가져다 쓸 때 여기부터
- [awesome-harness-engineering](https://github.com/ai-boost/awesome-harness-engineering) — 11개 설계 축. CLAUDE.md 범위를 넘는 하네스 전체
- [awesome-claude-code-toolkit](https://github.com/rohitg00/awesome-claude-code-toolkit) — 양이 많음. 골라 쓸 것

## 공식 문서

- [Hooks](https://code.claude.com/docs/en/hooks) — 이벤트 목록, matcher 문법, 차단 방법(exit 2 또는 permissionDecision)
- [Settings](https://code.claude.com/docs/en/settings) — 파일 우선순위. deny/ask는 즉시 적용, allow는 폴더 신뢰 후
- [Permissions](https://code.claude.com/docs/en/permissions) — 규칙 문법

---

## 읽을 때 주의

모음집의 CLAUDE.md는 대부분 수백 줄이다. **카탈로그이지 템플릿이 아니다.**

길이 자체가 문제는 아니고, 기준은 **"이 줄이 왜 있는지 설명할 수 있나"**. 남의 프로젝트 규칙이 섞여 들어오면 신호 대비 잡음이 올라간다.

컨텍스트를 먹는 것과 안 먹는 것을 구분할 것:

- **CLAUDE.md** — 매 요청 컨텍스트에 실린다. 겪은 다음에 한 줄씩 추가
- **훅·권한·슬래시 커맨드** — 실행 시점에만 작동. 미리 가져와도 부작용 없음
