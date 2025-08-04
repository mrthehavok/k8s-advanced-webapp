terraform {
  backend "s3" {
    bucket       = "k8s-tfstate-347913851454-eu-west-1"
    key          = "k8s-advanced-webapp/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}
