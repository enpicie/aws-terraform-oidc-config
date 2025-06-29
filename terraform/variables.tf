variable "tfe_organization" {
  description = "Terraform Cloud organization name"
  type        = string
  default     = "enpicie"
}

variable "workspace_names" {
  description = "List of TFC workspace names to attach the variable set to"
  type        = list(string)
  default = [
    "hcp-tf-aws-lambda-apigw-role",
  ]
}
