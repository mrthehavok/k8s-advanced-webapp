id: task-6
title: "Helm chart: frontend SPA with HPA & Ingress"
status: "In Progress"
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
- `Ingress` (ALB Ingress, annotation-driven) with TLS from cert-manager ClusterIssuer
  - Host configurable (`team-notes.example.com`)
- `HorizontalPodAutoscaler`
  - minReplicas 2, maxReplicas 5
  - CPU target 60 %
- Optional `ConfigMap` for runtime env
- Values for nodeSelector, tolerations, affinity, extraEnv

## Acceptance Criteria

- [ ] Chart in `charts/frontend/`
- [ ] `helm lint` passes
- [ ] HPA template renders only when enabled
- [ ] Example `values-dev.yaml` and `values-prod.yaml`
- [ ] README with values table

## Session History

- 2025-08-03 10:05: Started frontend Helm chart work; created feature branch.

## Decisions Made

## Files Modified

- `charts/frontend/**` (pending)

## Blockers

## Next Steps

- Scaffold with `helm create`
- Add Ingress & HPA templates
