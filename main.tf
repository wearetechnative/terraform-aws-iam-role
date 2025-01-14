resource "aws_iam_role" "this" {
  name = var.role_name
  path = local.validated_role_path

  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.trust_relationship.json
}

module "policy_helper" {
  source         = "github.com/wearetechnative/terraform-aws-iam-helper?ref=b5e28f28c11fd0f5733f0a0c8ad212bed4b99ff6"
  principal_type = "role"

  principal_name            = aws_iam_role.this.name
  customer_managed_policies = var.customer_managed_policies
  aws_managed_policies      = var.aws_managed_policies
}
