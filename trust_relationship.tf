data "aws_iam_policy_document" "useraccount_trust" {
  for_each = var.trust_relationship

  statement {
    sid     = each.key
    actions = ["sts:AssumeRole"]

    effect = "Allow"

    principals {
      type        = each.value.identifier_type
      identifiers = [each.value.identifier]
    }

    # https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html
    # prevent at least cross account confused deputy
    dynamic "condition" {
      for_each = each.value.prevent_account_confuseddeputy ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [data.aws_caller_identity.current.id]
      }
    }

    dynamic "condition" {
      for_each = each.value.enforce_userprincipal ? [1] : []
      content {
        test     = "StringEquals"
        variable = "aws:PrincipalType"
        values   = ["User"]
      }
    }

    dynamic "condition" {
      for_each = each.value.enforce_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = [true]
      }
    }

    dynamic "condition" {
      for_each = each.value.external_id != null ? [each.value.external_id] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [condition.value]
      }
    }
  }
}

data "aws_iam_policy_document" "trust_relationship" {
  source_policy_documents = [for k, v in data.aws_iam_policy_document.useraccount_trust : v.json]
}
