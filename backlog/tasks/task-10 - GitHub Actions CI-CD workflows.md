id: task-10
title: "GitHub Actions: Build, Test, Push Images & Update Helm Charts"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

## Description

Create GitHub Actions workflows to automate CI and CD:

1. **ci.yml**

   - Trigger: `pull_request`
   - Steps:
     - Checkout
     - Set up Node (frontend) & Python (backend)
     - Install dependencies
     - Run linters and unit tests
     - Upload coverage reports

2. **build-and-push.yml**

   - Trigger: `push` on `main` or version tag
   - Build Docker images for backend and frontend
   - Log in to GHCR (or Docker Hub)
   - Push images with `sha` and `latest` tags
   - Export image tags as workflow outputs

3. **update-helm-values.yml**
   - Trigger: workflow call from `build-and-push.yml`
   - Checkout `gitops` branch
   - Update `charts/*/values.yaml` image.tag with new digest/tag
   - Commit & push, opening PR if necessary
   - Optionally leverage Argo CD Image Updater

## Acceptance Criteria

- [ ] Workflow files under `.github/workflows/`
- [ ] CI workflow passes on PR with tests and lint
- [ ] Docker images appear in registry with correct tags
- [ ] Helm values auto-bump PR created or merged
- [ ] Documentation in `docs/ci-cd.md`

## Session History

- 2025-08-03 07:33: Backend Codecov removed; frontend image push to GHCR implemented (task-4 follow-up).

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Author workflow YAMLs
- Test in sandbox repository
- Add Helm release update automation for backend & frontend images.
