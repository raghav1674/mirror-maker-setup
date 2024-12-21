locals {
  region     = data.aws_region.current.id
  account_id = data.aws_caller_identity.current.account_id
}


locals {
  resource_arns = [
    "arn:aws:glue:${local.region}:${local.account_id}:schema/${var.schema_registry_name}/*",
    "arn:aws:glue:${local.region}:${local.account_id}:registry/${var.schema_registry_name}"
  ]

  principal_arns = concat([for account_id in var.account_ids : "arn:aws:iam::${account_id}:root"], var.principal_arns)

  policy_conditions = [
    {
      test     = "StringEquals"
      variable = "aws:userid"
      values   = ["12345689012"]
    }
  ]
}

