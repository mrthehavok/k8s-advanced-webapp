id: task-9
title: "Argo CD: App-of-Apps GitOps configuration"
status: "Done"
depends_on: ["task-2", "task-7"]
created: 2025-08-01
updated: 2025-08-01

## Description

Implement GitOps deployment workflow using Argo CD:

- Bootstrap Argo CD via Helm in `argocd` namespace:
  - Install using official Argo CD Helm chart
  - Configure with ingress
  - Set up admin credentials in AWS Secrets Manager
- Create an App-of-Apps root Application pointing to `gitops/apps/`
- Define child `Application` manifests:
  - `monitoring` (kube-prometheus-stack)
  - `backend` (notes API)
  - `frontend` (SPA)
- Add Argo CD Image Updater annotations for backend & frontend Applications so that any new image tag pushed to GHCR is detected and rolled out automatically:
  - `argocd-image-updater.argoproj.io/image-list: ghcr.io/your-org/backend,ghcr.io/your-org/frontend`
  - `argocd-image-updater.argoproj.io/<escaped_repo>.update-strategy: latest`
  - `argocd-image-updater.argoproj.io/refresh: always`
- Use sync-waves and dependency hooks to control order
- Separate `dev`, `monitoring` and `argocd` namespaces as destinations
- Enable automated sync with pruning and self-heal

## Acceptance Criteria

- [ ] Manifests under `gitops/` directory
- [ ] `kubectl apply --dry-run=server` yields no errors
- [ ] Argo CD UI shows all applications Healthy & Synced
- [ ] README section on Argo CD bootstrap

## Session History

- 2025-08-05: Live deployment applied, ALB address obtained. Admin password reset & login successful. Screenshot shows backend Degraded, cert-manager & aws-lb controller marked for removal.

## Decisions Made

- Use built-in AWS ALB ingress via Terraform/EKS annotations instead of a separate controller. This simplifies the stack and removes the need for `aws-load-balancer-controller` and `cert-manager`.
- Remove cert-manager and aws-load-balancer-controller Applications; backend health will be fixed in task-7b backend chart.

## Files Modified

- `gitops/argocd/install.yaml`
- `gitops/apps/*`
- `docs/architecture.md`
- `docs/terraform-eks-design.md`
- `docs/frontend-helm-chart-design.md`

## Blockers

## Next Steps

None.
