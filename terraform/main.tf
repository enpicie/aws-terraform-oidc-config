data "tfe_organization" "hcp_organization" {
  name = var.tfe_organization
}

resource "tfe_variable_set" "oidc_role_variable_set" {
  name         = "OIDC Execution Role - IAM Perms"
  description  = "TFC variable set with the role ARN used by OIDC with permissions to provision IAM resources."
  organization = data.tfe_organization.hcp_organization.name
  global       = false
}

resource "tfe_variable" "role_arn_var" {
  key = "TFC_AWS_RUN_ROLE_ARN"
  # ARN of role created by the CloudFormation template in terraform-oidc.yml
  # THIS SHOULD NEVER NEED TO BE CHANGED.
  value           = "arn:aws:iam::637423387388:role/HCP-Terraform-Role"
  category        = "env"
  variable_set_id = tfe_variable_set.oidc_role_variable_set.id
}

# Attach to multiple workspaces by name
data "tfe_workspace" "targets" {
  for_each     = toset(var.workspace_names)
  name         = each.key
  organization = var.tfe_organization
}

resource "tfe_workspace_variable_set" "attachment" {
  for_each        = data.tfe_workspace.targets
  workspace_id    = each.value.id
  variable_set_id = tfe_variable_set.oidc_role_variable_set.id
}
