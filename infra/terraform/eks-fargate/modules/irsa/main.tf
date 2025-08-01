# IAM Roles for Service Accounts (IRSA)
#
# This module creates one IAM role per service defined in `var.irsa_configs`,
# builds a trust relationship with the cluster's OIDC provider, attaches an
# inline policy from the bundled JSON documents, and exposes a map of role ARNs.
#
# Expectations:
#   • The filenames under ./policies/ must match the `irsa_configs` keys
#     (e.g., "alb-controller" → policies/alb-controller.json).
#   • `enable_irsa` toggles whether resources are created at all.
#

locals {
  enabled = var.enable_irsa
  # Conditionally empty map when disabled to avoid resource creation.
  irsa_configs = var.enable_irsa ? var.irsa_configs : {}
  # Extract issuer host component required by IAM condition key.
  oidc_sub_key = replace(var.oidc_provider_url, "https://", "")
}

#############################
# IAM role per service account
#############################
resource "aws_iam_role" "irsa" {
  for_each = local.irsa_configs

  name = "${var.project_name}-${var.environment}-${each.key}-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${local.oidc_sub_key}:sub" = "system:serviceaccount:${each.value.namespace}:${each.value.service_account_name}"
        }
      }
    }]
  })

  tags = merge(
    var.tags,
    {
      "Project"      = var.project_name
      "Environment"  = var.environment
      "IRSA-Service" = each.key
    }
  )
}

##################################
# Inline policy per service (JSON)
##################################
resource "aws_iam_policy" "irsa" {
  for_each = local.irsa_configs

  name   = "${var.project_name}-${var.environment}-${each.key}-policy"
  policy = file("${path.module}/policies/${each.key}.json")
}

############################################
# Attach the policy to the corresponding role
############################################
resource "aws_iam_role_policy_attachment" "irsa" {
  for_each = local.irsa_configs

  role       = aws_iam_role.irsa[each.key].name
  policy_arn = aws_iam_policy.irsa[each.key].arn
}
