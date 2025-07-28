# aws-terraform-oidc-config

CloudFormation template for OIDC provider and IAM Role for HCP Terraform runs to provision further IAM roles assumable via OIDC.

This role is intended to be consumed by other Terraform configs that provision IAM resources for specific sets of permissions for different use cases. For example, a separate config will provision a role to allow Terraform to manage Lambda and API Gateway resources, and it will consume the role deployed via this repo to do so.

## Usage

Call [action-workflow-hcp-terraform-var-set-attach](https://github.com/enpicie/action-workflow-hcp-terraform-var-set-attach) like this:

```yaml
- name: Attach IAM Permissions Variable Set to this Workspace
  uses: chzylee/action-workflow-hcp-terraform-var-set-attach@v1.0.0
  with:
    tfc_organization: ${{ env.HCP_TERRAFORM_ORG }}
    tfc_workspace_id: ${{ steps.setup_workspace.outputs.workspace_id }}
    tfc_token: ${{ secrets.TF_API_TOKEN }}
    var_set_name: ${{ vars.AWS_TF_ROLE_VARSET_IAM}}
```

This attaches the HCP Terraform Variable set referencing the permissions provisioned by this config to a workspace to allow Terraform to assume the role with these permissions.

## OIDC Provider Thumbprint

The CA's thumbprint establishes trust between AWS and the OIDC provider's registered DNS name. Here are the steps to get the thumbprint:

1. Install `openssl` CLI tool.
2. Run `echo | openssl s_client -connect app.terraform.io:443 -servername app.terraform.io 2>/dev/null | openssl x509 -fingerprint -noout -sha1`
   - Output will have format like `sha1 Fingerprint=29:11:24:B9:77:C9:9A:C0:40:0A:90:E3:12:3D:E4:AD:86:F7:6E:99`
3. Remove colons fromt he value of the fingerprint and the result is the thumbprint.

CA Thumbprints are public and thus safe to commit.
