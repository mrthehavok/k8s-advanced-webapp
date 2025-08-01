# AIDEV-TODO: Replace with actual resource outputs.
output "role_arns" {
  description = "Map of IRSA role ARNs"
  value = {
    "alb-controller" = "arn:aws:iam::123456789012:role/placeholder-alb"
    "cert-manager"   = "arn:aws:iam::123456789012:role/placeholder-cert-manager"
    "external-dns"   = "arn:aws:iam::123456789012:role/placeholder-external-dns"
  }
}
