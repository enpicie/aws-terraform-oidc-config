# aws-terraform-oidc-config

CloudFormation template for OIDC provider and IAM Role for HCP Terraform runs to provision further IAM roles assumable via OIDC.

This role is intended to be consumed by other Terraform configs that provision IAM resources for specific sets of permissions for different use cases. For example, a separate config will provision a role to allow Terraform to manage Lambda and API Gateway resources, and it will consume the role deployed via this repo to do so.

## Deployments

- "HCP-Terraform-Role" and OIDC Provider "HCP-Terraform-OIDC-Provider" to AWS
- "OIDC Execution Role - IAM Perms" variable set to HCP Terraform
  - Contains reference to the HCP-Terraform-Role role for other Workspaces to consume to provision IAM resources.

## Usage

Add the HCP Terraform Workspace name to `workspace_names` list in [workspaces.tfvars](./terraform/workspaces.tfvars) and push to trigger the GitHub Actions pipeline.

The GitHub Actions pipeline will deploy [the CloudFormation template](./terraform-oidc.yml) to AWS. The created IAM Role's ARN is used in [the Terraform config](./terraform/main.tf) to add this role to an HCP Terraform variable set with variables named for HCP Terraform to use the role to authenticate to AWS for IAM provisioning.

The Role ARN is _NOT_ considered sensitive information, so it is safe to commit in this code and should not need to be changed.

## OIDC Provider Thumbprint

The CA's thumbprint establishes trust between AWS and the OIDC provider's registered DNS name. Here are the steps to get the thumbprint:

1. Install `openssl` CLI tool.
2. Run `echo | openssl s_client -connect app.terraform.io:443 -servername app.terraform.io 2>/dev/null | openssl x509 -fingerprint -noout -sha1`
   - Output will have format like `sha1 Fingerprint=29:11:24:B9:77:C9:9A:C0:40:0A:90:E3:12:3D:E4:AD:86:F7:6E:99`
3. Remove colons fromt he value of the fingerprint and the result is the thumbprint.

CA Thumbprints are public and thus safe to commit.
