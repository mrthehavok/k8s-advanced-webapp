# IRSA Role ARNs
#
# Expose a map keyed by the IRSA service name (e.g., "alb-controller")
# containing the corresponding IAM role ARN. Returns an empty map when
# IRSA is disabled.
output "role_arns" {
  description = "Map of IRSA role ARNs created by this module"
  value       = var.enable_irsa ? { for k, v in aws_iam_role.irsa : k => v.arn } : {}
}
