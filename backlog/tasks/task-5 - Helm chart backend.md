id: task-5
title: "Helm chart: backend service"
status: "Done"
depends_on: ["task-3"]
created: 2025-08-01
updated: 2025-08-03

## Description

Package the FastAPI backend as a standalone Helm chart.

Chart requirements:

- `Deployment` with:
  - Image repository & tag from `values.yaml`
  - Environment variables for DB path
  - Resource requests (100m CPU / 128Mi) and limits (250m / 256Mi)
  - Liveness `/healthz` & readiness `/readyz` probes
- `Service` ClusterIP on port 8000
- `ConfigMap` for application settings
- `PodDisruptionBudget` (minAvailable: 1)
- Support `extraEnv`, `nodeSelector`, `tolerations`, `affinity`
- Parameterise SQLite PVC (optional)
- Versioned via SemVer

## Acceptance Criteria

- [x] Chart in `charts/backend/`
- [x] `helm lint` passes
- [x] `helm template` renders with default values
- [x] README with values table
- [x] Example `values-dev.yaml` used by Argo CD

## Session History

- 2025-08-03 10:00: Completed all chart work and created PR.

## Decisions Made

## Files Modified

- `charts/backend/**`

## Blockers

## Next Steps

- Scaffold chart using `helm create`
- Strip defaults, add probes & resources
