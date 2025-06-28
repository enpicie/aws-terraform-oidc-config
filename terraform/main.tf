provider "aws" {
  region = "us-east-2"
}

# No token needed. Authenticating to HCP Terraform via repo secret withh TF_API_TOKEN.
provider "tfe" {}

data "aws_iam_role" "oidc_execution_role" {
  # Role defined in terraform-oidc.yaml CloudFormation template.
  name = "HCP-Terraform-Role"
}
