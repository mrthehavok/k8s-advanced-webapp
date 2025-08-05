id: task-7a
title: "End-to-end smoke test"
status: "Done"
created: 2025-08-03
updated: 2025-08-05

## Description

After Helm charts for the backend (task-6) and frontend (task-7) are packaged, deploy them to the dev EKS Fargate cluster and verify that the complete application works.

## Acceptance Criteria

- [ ] Backend and frontend charts installed via `helm upgrade --install` (dev namespace)
- [ ] Pods reach **Ready** state; services obtain ClusterIP
- [ ] Ingress resolves with valid TLS cert (CLUSTER_ISSUER from previous tasks)
- [ ] `curl https://<domain>/api/health` returns `{"status":"ok"}`
- [ ] Frontend URL shows notes list and CRUD operations work end-to-end
- [ ] CI job outputs deployment logs and marks pipeline green on success
- [ ] Backend image automatically built & pushed to GitHub Container Registry by CI workflow
- [ ] Frontend image automatically built & pushed to GitHub Container Registry by CI workflow
- [ ] Kubernetes dev namespace runs the _latest_ images produced by CI/CD (verified by tag or digest)

## Session History

- 2025-08-04 13:46: Started smoke-test deployment; created feature branch.
- 2025-08-04 16:40: Clean Terraform plan achieved; helm releases deployed
- 2025-08-04 16:48: Backend pod `ImagePullBackOff` due to missing image; manual docker build failed to push (Docker Hub auth)
- 2025-08-04 16:51: Decided to switch to GHCR and implement automated build workflows for backend & frontend images
- 2025-08-05 07:50: Fixed backend CrashLoop by rebuilding image; added ServiceAccount to frontend, pods running, URL retrieved
- 2025-08-05 10:28: Ingress successfully provisioned with working URL: http://k8s-dev-frontend-bb957671cb-158967001.eu-west-1.elb.amazonaws.com

## Decisions Made

- Use GitHub Container Registry (ghcr.io) for all service images
- Standardise image tags as `main-<SHA>` plus `latest`
- Use in-memory SQLite for dev environment
- Adopt explicit ServiceAccount pattern for frontend chart

### Smoke Test Deployment Plan

#### Prerequisites

- The Terraform backend defined in `infra/terraform/eks-fargate` has been successfully applied for the `dev` environment.

#### Helm Installation Order

The Helm charts will be installed in the `dev` namespace in the following order:

1.  `charts/backend`
2.  `charts/frontend`

#### Values Overrides

The following values will be overridden in `values-dev.yaml` or via `--set` flags:

- **Image Tags**: The `image.tag` for both frontend and backend will be set to the latest tag from our CI pipeline.
- **Service Account**: If required, `serviceAccount.name` will be configured for IRSA.
- **Resource Limits**: CPU and memory `resources.limits` and `resources.requests` will be adjusted based on load testing.

#### Execution Commands

```bash
# 1. Ensure the EKS cluster is up-to-date
terraform -chdir=infra/terraform/eks-fargate apply -var-file=envs/dev.tfvars

# 2. Deploy the backend service
helm upgrade --install backend charts/backend -n dev --create-namespace -f charts/backend/values-dev.yaml

# 3. Deploy the frontend service
helm upgrade --install frontend charts/frontend -n dev -f charts/frontend/values-dev.yaml

# 4. Verify pod status
kubectl get pods -n dev

# 5. Port-forward the frontend service for local validation
kubectl port-forward svc/frontend 8080:80
```

#### Success Validation

The deployment will be considered successful if:

- `curl http://localhost:8080` returns the main HTML page of the application.
- `curl http://localhost:8080/api/health` returns a JSON payload `{"status":"ok"}`.

#### Rollback Strategy

- **Immediate Rollback**: If validation fails, we will use `helm rollback <release-name> <revision>` to revert to the last known good release.
- **Troubleshooting**: The most likely areas for issues are:
  - **Images**: Incorrect image tags or image pull errors.
  - **Resources**: Insufficient CPU/memory requests or limits causing pod crashes.
  - **Probes**: Liveness or readiness probes failing, causing restart loops.

## Files Modified

- .github/workflows/backend-ci.yml (added)
- .github/workflows/frontend-ci.yml (updated)
- charts/backend/templates/deployment.yaml (updated)
- charts/backend/values.yaml (updated)
- charts/frontend/templates/serviceaccount.yaml (added)
- README.md (added)
- services/backend/app/main.py (updated to add /api prefix to all routes)
- charts/backend/values.yaml (updated probe paths to include /api prefix)
- charts/frontend/values.yaml (updated to remove hostname restriction)
- charts/frontend/templates/ingress.yaml (updated to remove host-based routing)

## Blockers

<!-- Document any blockers encountered -->

## Next Steps

- Integrate persistent database (e.g., RDS Postgres) instead of in-memory SQLite
- Add GitHub Actions end-to-end smoke-test job
