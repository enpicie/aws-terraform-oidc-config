data "tfe_organization" "hcp_organization" {
  name = var.tfe_organization
}

resource "tfe_variable_set" "oidc_role_variable_set" {
  name         = "AWS HCP TF OIDC Role - IAM Perms"
  description  = "TFC variable set with the role ARN used by OIDC with permissions to provision IAM resources."
  organization = data.tfe_organization.hcp_organization.name
  global       = false
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  key             = "TFC_AWS_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.oidc_role_variable_set.id
}

resource "tfe_variable" "role_arn_var" {
  key = "TFC_AWS_RUN_ROLE_ARN"
  # ARN of role created by the CloudFormation template in terraform-oidc.yml
  # THIS SHOULD NEVER NEED TO BE CHANGED.
  # This is safe to commit as access is restricted to only allow "enpicie" HCP org.
  value           = "arn:aws:iam::637423387388:role/HCP-Terraform-IAM-Provisioner-Role"
  category        = "env"
  variable_set_id = tfe_variable_set.oidc_role_variable_set.id
}
