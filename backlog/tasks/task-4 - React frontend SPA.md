id: task-4
title: "React frontend SPA: Team Notes UI"
status: "In Progress"
created: 2025-08-01
updated: 2025-08-03

## Description

Develop a lightweight React single-page application for “Team Notes”:

- Pages:
  - Notes list with search & create button
  - Note editor (Markdown textarea with preview)
  - Note view/read mode
- API integration with backend CRUD endpoints
- State management: React Query or simple context/hooks
- Routing via React Router v6
- Styling: TailwindCSS or minimal CSS-in-JS
- Environments: base URL from env vars
- Liveness route: `/` returns static index

## Acceptance Criteria

- [ ] Source in `services/frontend/` (TypeScript, Vite or CRA)
- [ ] `Dockerfile` multi-stage, final image <150 MB
- [ ] Unit/component tests (Jest + React Testing Library) ≥80 %
- [ ] GitHub Action runs lint & tests
- [ ] App works against local backend (makefile/dev script)
- [ ] README with dev and build instructions

## Session History

<!-- Update as work progresses -->

- 2025-08-03 07:04: Started task; created feature branch.

## Decisions Made

<!-- Document key decisions -->

## Files Modified

<!-- Track all file changes -->

## Blockers

<!-- Document any blockers -->

## Next Steps

- Scaffold React app, configure Tailwind
- Implement list page, editor, view
- Write docker & tests
