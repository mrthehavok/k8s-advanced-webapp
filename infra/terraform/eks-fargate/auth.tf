# Create or update the aws-auth ConfigMap with user mappings
# Note: This will only work after the EKS cluster is created
resource "kubernetes_config_map_v1_data" "aws_auth" {
  count = length(var.aws_auth_users) > 0 ? 1 : 0

  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    # Add our user mappings
    mapUsers = yamlencode(var.aws_auth_users)
  }

  # Ensure this runs after the cluster is ready
  depends_on = [module.eks_cluster]
}
