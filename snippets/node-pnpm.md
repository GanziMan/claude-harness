<!-- CLAUDE.md 의 '프로젝트 정보' 블록에 붙여넣기 -->

# 프로젝트 정보

- 스택: TypeScript, Next.js (App Router), NestJS
- 패키지 매니저: pnpm — `npm`/`yarn` 명령을 쓰지 않는다
- 설치: `pnpm install --frozen-lockfile`
- 개발 서버: `pnpm dev`
- 타입체크: `pnpm tsc --noEmit`
- 린트: `pnpm lint`
- 테스트: `pnpm test` (단일 파일: `pnpm test <path>`)
- ORM: Prisma. 스키마는 `prisma/schema.prisma`
- 상세 문서: `docs/` 참고

## 이 프로젝트 규칙

- 서버 컴포넌트가 기본. `"use client"`는 필요한 최소 단위 컴포넌트에만 붙인다.
- API 응답 타입은 zod 스키마에서 추론한다. 수동으로 interface를 중복 정의하지 않는다.
- 마이그레이션은 `pnpm prisma migrate dev --name <설명>`으로 생성한다. SQL을 직접 쓰지 않는다.
