# aws-terraform-oidc-config

CloudFormation template for OIDC provider and IAM Role for HCP Terraform runs to provision further roles assumable via OIDC.

## Usage

This repo has a GitHub Actions pipeline that will deploy the CloudFormation template to AWS. The created IAM Role's ARN can be used with Terraform to configure IAM Roles with different permissions needed for different projects' needs.

GitHub Actions will receive create permissions via IAM Role manually created in AWS Console associated with the GitHub Actions OIDC provider. That is the only manual step needed to automate deployment of further roles and permissions.

## OIDC Provider Thumbprint

The CA's thumbprint establishes trust between AWS and the OIDC provider's registered DNS name. Here are the steps to get the thumbprint:

1. Install `openssl` CLI tool.
2. Run `echo | openssl s_client -connect app.terraform.io:443 -servername app.terraform.io 2>/dev/null | openssl x509 -fingerprint -noout -sha1`
   - Output will have format like `sha1 Fingerprint=29:11:24:B9:77:C9:9A:C0:40:0A:90:E3:12:3D:E4:AD:86:F7:6E:99`
3. Remove colons fromt he value of the fingerprint and the result is the thumbprint.

CA Thumbprints are public and thus safe to commit.
