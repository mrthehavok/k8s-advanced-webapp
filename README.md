# k8s-advanced-webapp

## First-time setup (AWS **dev** environment)

1. Clone this repository and configure your AWS credentials (`aws configure`), ensuring the account has permissions to provision EKS and related resources.

2. Provision the EKS Fargate infrastructure:

```bash
cd infra/terraform/eks-fargate
terraform init
terraform apply -var-file=envs/dev.tfvars
```

3. Build **and push** multi-architecture Docker images for the backend and frontend (or let GitHub Actions do this for you):

```bash
# Local multi-arch build (optional)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/<org>/backend:latest services/backend --push

docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/<org>/frontend:latest services/frontend --push
```

4. Create a GitHub Container Registry secret in the `dev` namespace so the cluster can pull images:

```bash
kubectl -n dev create secret docker-registry ghcr-credentials \
  --docker-server=ghcr.io \
  --docker-username=<github-username> \
  --docker-password=<ghcr-token> \
  --docker-email=<email>
```

5. Install Helm releases for the backend and frontend:

```bash
helm upgrade --install backend  ./charts/backend  -n dev --create-namespace
helm upgrade --install frontend ./charts/frontend -n dev
```

6. Verify the pods and obtain the ingress URL:

```bash
kubectl get ingress -n dev
# ADDRESS column should show the ALB address, e.g.: k8s-dev-frontend-bb957671cb-158967001.eu-west-1.elb.amazonaws.com
```

7. Smoke-test the deployment:

```bash
# Backend health endpoint
curl http://k8s-dev-frontend-bb957671cb-158967001.eu-west-1.elb.amazonaws.com/api/healthz
# → {"status":"ok"}

# Open the UI in your browser
open http://k8s-dev-frontend-bb957671cb-158967001.eu-west-1.elb.amazonaws.com
```

---

For production deployments, see the documentation under `docs/` and the corresponding Terraform and Helm values files.
