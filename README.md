# k8s-advanced-webapp

## First-time setup (AWS **dev** environment)

1. Clone this repository and configure your AWS credentials (`aws configure`), ensuring the account has permissions to provision EKS and related resources.

2. Provision the EKS Fargate infrastructure:

```bash
cd infra/terraform/eks-fargate
terraform init
terraform apply -var-file=envs/dev.tfvars
```

3. Build and push Docker images for the backend and frontend. For the `dev` environment, we use the `latest` tag.

```bash
# Build and push the backend image
docker build -t ghcr.io/mrthehavok/k8s-advanced-webapp-backend:latest ./services/backend --push

# Build and push the frontend image
docker build -t ghcr.io/mrthehavok/k8s-advanced-webapp-frontend:latest ./services/frontend --push
```

4. Create a GitHub Container Registry secret in the `dev` namespace so the cluster can pull images (if your repository is private):

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

The application is now fully deployed. The frontend will be available at the address provided by the ingress, and it is configured to communicate with the backend API.

---

For production deployments, see the documentation under `docs/` and the corresponding Terraform and Helm values files.
