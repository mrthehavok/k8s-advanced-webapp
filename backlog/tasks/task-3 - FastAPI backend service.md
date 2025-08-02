id: task-3
title: "FastAPI backend service: CRUD notes, SQLite storage"
status: "In Progress"
created: 2025-08-01
updated: 2025-08-01

## Description

Implement the backend microservice for “Team Notes” using FastAPI:

- Endpoints:
  - `GET /notes` list all notes
  - `POST /notes` create note (title, markdown)
  - `GET /notes/{id}` retrieve note
  - `PUT /notes/{id}` update note
  - `DELETE /notes/{id}` remove note
- Data model: id, title, content (markdown), created_at, updated_at
- Persistence: SQLite file (mounted writeable volume); fallback to in-memory for tests
- Use Pydantic models & validation
- Add OpenAPI docs (FastAPI default)
- Basic pagination on list endpoint (limit, offset)
- Liveness `/healthz` and readiness `/readyz` routes
- CORS configuration to allow frontend API calls

## Acceptance Criteria

- [ ] Source code in `services/backend/` with Poetry or requirements.txt
- [ ] `Dockerfile` builds lean image (<100 MB) via multi-stage
- [ ] Unit tests (pytest) ≥90 % coverage for CRUD logic
- [ ] Automated GitHub Action running tests
- [ ] Container responds to health probes within 2 s
- [ ] README with local run instructions

## Session History

- 2025-08-02T14:20:39Z: Agent started work on [task-3].

## Decisions Made

<!-- Document implementation decisions -->

## Files Modified

- `services/backend/pyproject.toml`
- `services/backend/app/__init__.py`
- `services/backend/app/main.py`
- `services/backend/app/db.py`
- `services/backend/app/models.py`
- `services/backend/app/crud.py`
- `services/backend/app/routers/notes.py`
- `services/backend/tests/test_notes.py`
- `services/backend/Dockerfile`
- `services/backend/README.md`
- `.github/workflows/backend-ci.yml`

## Blockers

<!-- Document any blockers -->

## Next Steps

- Design Pydantic schemas
- Implement CRUD routes
- Write tests and Dockerfile
