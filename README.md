# Terraform AWS [iam-role]

This module implements a module to create roles and easily define trust relationships.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage

A mostly complete example is demonstrated below.


```hcl
module "dreamlines_website_cicd_build_role" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-iam-role?ref=HEAD" # change to commit or version later

  role_name = "website_stack_role"
  role_path = "/website_stack/ci_cd/"

  aws_managed_policies      = [ "AdministratorAccess" ]
  customer_managed_policies = {
    "website_codebuild_cloudwatch": jsondecode(data.aws_iam_policy_document.website_codebuild_cloudwatch.json)
  }

  trust_relationship = {
    "codebuild" : { "identifier" : "codebuild.amazonaws.com", "identifier_type" : "Service", "enforce_mfa" : false, "enforce_userprincipal" : false, "external_id" : null, "prevent_account_confuseddeputy" : false }
  }
}

data "aws_iam_policy_document" "website_codebuild_cloudwatch" {
  statement {
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [ "arn:${data.aws_partition.current.id}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/website_stack_website_*" ]
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_policy_helper"></a> [policy\_helper](#module\_policy\_helper) | git@github.com:wearetechnative/terraform-aws-iam-helper | b5e28f28c11fd0f5733f0a0c8ad212bed4b99ff6 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.trust_relationship](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.useraccount_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_managed_policies"></a> [aws\_managed\_policies](#input\_aws\_managed\_policies) | Optional list of AWS managed policies. We assume that these policies already exist. | `list(string)` | `[]` | no |
| <a name="input_customer_managed_policies"></a> [customer\_managed\_policies](#input\_customer\_managed\_policies) | Optional map of customer managed policy names. Key is policyname and value is policy object in HCL. | `any` | `{}` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Role name for new role. Required value. | `string` | n/a | yes |
| <a name="input_role_path"></a> [role\_path](#input\_role\_path) | Path for new role. Defaults to "/". | `string` | `"/"` | no |
| <a name="input_trust_relationship"></a> [trust\_relationship](#input\_trust\_relationship) | Defines trust relationships on this role.<br>About prevent\_account\_confuseddeputy see https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html .<br>TODO: It would be best to remove this parameter and have a list of affected principals within our terraform-aws-module-iam-policy-helper with an override to disable if necessary. | <pre>map(object({<br>    identifier                     = string<br>    identifier_type                = string # either AWS or Service<br>    enforce_mfa                    = bool<br>    enforce_userprincipal          = bool<br>    external_id                    = string<br>    prevent_account_confuseddeputy = bool<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | n/a |
<!-- END_TF_DOCS -->
