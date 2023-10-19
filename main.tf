resource "aws_iam_role" "this" {
  name = var.role_name
  path = local.validated_role_path

  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.trust_relationship.json
}

module "policy_helper" {
  source         = "git@github.com:TechNative-B-V/terraform-aws-module-iam-policy-helper.git?ref=ced5ee6d207f723d802b65374804ca7e123f175e"
  principal_type = "role"

  principal_name            = aws_iam_role.this.name
  customer_managed_policies = var.customer_managed_policies
  aws_managed_policies      = var.aws_managed_policies
}
