id: task-9
title: "Argo CD: App-of-Apps GitOps configuration"
status: "To Do"
depends_on: ["task-2", "task-7"]
created: 2025-08-01
updated: 2025-08-01

## Description

Implement GitOps deployment workflow using Argo CD:

- Bootstrap Argo CD via Helm in `argocd` namespace:
  - Install using official Argo CD Helm chart
  - Configure with ingress and TLS
  - Set up admin credentials in AWS Secrets Manager
- Create an App-of-Apps root Application pointing to `gitops/apps/`
- Define child `Application` manifests:
  - `infra` (load balancer controller, cert-manager)
  - `monitoring` (kube-prometheus-stack)
  - `backend` (notes API)
  - `frontend` (SPA)
- Add Argo CD Image Updater annotations for backend & frontend Applications so that any new image tag pushed to GHCR is detected and rolled out automatically:
  - `argocd-image-updater.argoproj.io/image-list: ghcr.io/your-org/backend,ghcr.io/your-org/frontend`
  - `argocd-image-updater.argoproj.io/<escaped_repo>.update-strategy: latest`
  - `argocd-image-updater.argoproj.io/refresh: always`
- Use sync-waves and dependency hooks to control order
- Separate `dev`, `monitoring`, `cert-manager`, and `argocd` namespaces as destinations
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
- Patch gitops/apps/frontend.yaml and gitops/apps/backend.yaml with the image-updater annotations.
