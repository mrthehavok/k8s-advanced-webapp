id: task-9
title: "Argo CD: App-of-Apps GitOps configuration"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

## Description

Implement GitOps deployment workflow using Argo CD:

- Bootstrap Argo CD via Helm in `argocd` namespace
- Create an App-of-Apps root Application pointing to `gitops/apps/`
- Define child `Application` manifests:
  - `infra` (load balancer controller, cert-manager)
  - `monitoring` (kube-prometheus-stack)
  - `backend` (notes API)
  - `frontend` (SPA)
- Use sync-waves and dependency hooks to control order
- Separate `dev` and `monitoring` namespaces as destinations
- Enable automated sync with pruning and self-heal

## Acceptance Criteria

- [ ] Manifests under `gitops/` directory
- [ ] `kubectl apply --dry-run=server` yields no errors
- [ ] Argo CD UI shows all applications Healthy & Synced
- [ ] README section on Argo CD bootstrap

## Session History

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Scaffold root application
- Add child app manifests
