id: task-6
title: "Helm chart: frontend SPA with HPA & Ingress"
status: "Done"
depends_on: ["task-4"]
created: 2025-08-01
updated: 2025-08-03

## Description

Package the React frontend as a Helm chart that exposes it via HTTPS Ingress and enables autoscaling.

Chart requirements:

- `Deployment`
  - Image repo & tag from `values.yaml`
  - Resources: requests 100m CPU / 128Mi, limits 300m / 256Mi
  - Liveness `/` probe, readiness `/` probe
- `Service` ClusterIP on port 80
- `Ingress` (ALB Ingress, annotation-driven)
- `HorizontalPodAutoscaler`
  - minReplicas 2, maxReplicas 5
  - CPU target 60 %
- Optional `ConfigMap` for runtime env
- Values for nodeSelector, tolerations, affinity, extraEnv

## Acceptance Criteria

- [x] Chart in `charts/frontend/`
- [x] `helm lint` passes
- [x] HPA template renders only when enabled
- [x] Example `values-dev.yaml` and `values-prod.yaml`
- [x] README with values table

## Session History

- 2025-08-03 10:05: Started frontend Helm chart work; created feature branch.
- 2025-08-03 10:07: Completed frontend Helm chart design document.
- 2025-08-03 10:26: Scaffolded Helm chart and created all templates.
- 2025-08-03 10:38: Marked task as complete; all acceptance criteria met.

## Decisions Made

- Created comprehensive design document covering chart structure, values schema, and implementation patterns
- Decided to use conditional HPA rendering based on `.Values.autoscaling.enabled`
- Planned for optional ConfigMap to support runtime configuration
- Designed for ALB Ingress

## Files Modified

- `docs/frontend-helm-chart-design.md` (created)
- `charts/frontend/Chart.yaml` (created)
- `charts/frontend/values.yaml` (created)
- `charts/frontend/values-dev.yaml` (created)
- `charts/frontend/values-prod.yaml` (created)
- `charts/frontend/README.md` (created)
- `charts/frontend/.helmignore` (created)
- `charts/frontend/templates/_helpers.tpl` (created)
- `charts/frontend/templates/deployment.yaml` (created)
- `charts/frontend/templates/service.yaml` (created)
- `charts/frontend/templates/ingress.yaml` (created)
- `charts/frontend/templates/hpa.yaml` (created)
- `charts/frontend/templates/NOTES.txt` (created)
- `.github/workflows/frontend-ci.yml` (created)

## Blockers

None - all work completed successfully.

## Next Steps

- Deploy to dev environment for testing
- Configure ingress controller (task-7)
- Integrate with Argo CD for GitOps deployment (task-9)
