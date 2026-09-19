<!-- CLAUDE.md 의 '프로젝트 정보' 블록에 붙여넣기 -->

# 프로젝트 정보

- 스택: Python 3.12, FastAPI, SQLAlchemy 2.0, Alembic
- 패키지 매니저: uv — `pip install`을 직접 쓰지 않는다
- 설치: `uv sync`
- 개발 서버: `uv run uvicorn app.main:app --reload`
- 타입체크: `uv run mypy app`
- 린트: `uv run ruff check app`
- 테스트: `uv run pytest` (단일: `uv run pytest <path>::<test>`)
- 상세 문서: `docs/` 참고

## 이 프로젝트 규칙

- 라우터는 얇게. 비즈니스 로직은 `app/services/`에 둔다.
- 요청·응답 모델은 Pydantic으로 정의한다. dict를 그대로 반환하지 않는다.
- DB 세션은 의존성 주입으로 받는다. 전역 세션을 만들지 않는다.
- 마이그레이션은 `uv run alembic revision --autogenerate -m "<설명>"`으로 생성하고, 생성된 파일을 확인한 뒤 적용한다.
- 동기 I/O를 async 함수 안에서 직접 호출하지 않는다.
