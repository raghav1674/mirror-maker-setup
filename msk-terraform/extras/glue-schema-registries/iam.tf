data "aws_iam_policy_document" "cross_account_role_policy" {
  for_each = var.cross_account_access

  statement {
    effect = "Allow"
    actions = [
      "glue:GetSchemaByDefinition",
      "glue:CreateSchema",
      "glue:RegisterSchemaVersion",
      "glue:PutSchemaVersionMetadata",
      "glue:UpdateSchema",
      "glue:DeleteSchema",
    ]

    resources = concat(
      [for registry in each.value.registries : "arn:aws:glue:${local.region}:${local.account_id}:schema/${registry}/*"],
      [for registry in each.value.registries : "arn:aws:glue:${local.region}:${local.account_id}:registry/${registry}"]
    )
  }
  statement {
    effect  = "Allow"
    actions = ["glue:GetSchemaVersion"]
    resources = concat(
      [for registry in each.value.registries : "arn:aws:glue:${local.region}:${local.account_id}:schema/${registry}/*"],
      [for registry in each.value.registries : "arn:aws:glue:${local.region}:${local.account_id}:registry/${registry}"]
    )
  }
}


data "aws_iam_policy_document" "glue_assume_role_policy" {
  for_each = var.cross_account_access
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = concat(["arn:aws:iam::${each.value.account_id}:root"], each.value.prinicipal_arns)
    }
    dynamic "condition" {
      for_each = each.value.policy_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
  lifecycle {
    precondition {
      condition     = length(each.value.prinicipal_arns) > 0 || length(each.value.policy_conditions) > 0
      error_message = "Either principal_arns or iam policy_conditions must be provided for ${each.key} cross account access"
    }
  }
}

resource "aws_iam_role" "glue_cross_account_role" {
  for_each           = var.cross_account_access
  name               = "${each.key}_GlueSchemaAccessRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy[each.key].json
}

resource "aws_iam_role_policy" "cross_account_role_policy" {
  for_each = var.cross_account_access
  role     = aws_iam_role.glue_cross_account_role[each.key].name
  policy   = data.aws_iam_policy_document.cross_account_role_policy[each.key].json
}






