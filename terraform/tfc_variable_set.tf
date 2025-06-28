resource "tfe_variable_set" "oidc_role_variable_set" {
  name         = "OIDC Execution Role ARN"
  description  = "TFC variable set with the role ARN used by OIDC with permissions to provision IAM resources."
  organization = var.tfe_organization
  global       = false
}

resource "tfe_variable" "role_arn_var" {
  key             = "TFC_AWS_RUN_ROLE_ARN"
  value           = data.aws_iam_role.oidc_execution_role.arn
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
