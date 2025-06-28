variable "tfe_organization" {
  description = "Terraform Cloud organization name"
  type        = string
}

variable "workspace_names" {
  description = "List of TFC workspace names to attach the variable set to"
  type        = list(string)
}
