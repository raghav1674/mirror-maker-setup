data "aws_iam_policy_document" "cross_account_role_policy" {
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

    resources = local.resource_arns
  }
  statement {
    effect    = "Allow"
    actions   = ["glue:GetSchemaVersion"]
    resources = local.resource_arns
  }
}


data "aws_iam_policy_document" "glue_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = local.principal_arns
    }
    dynamic "condition" {
      for_each = local.policy_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_role" "glue_cross_account_role" {
  name               = coalesce(var.schema_registry_assume_role_name, "${var.schema_registry_name}_GlueSchemaAccessRole")
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "cross_account_role_policy" {
  role   = aws_iam_role.glue_cross_account_role.name
  policy = data.aws_iam_policy_document.cross_account_role_policy.json
}






