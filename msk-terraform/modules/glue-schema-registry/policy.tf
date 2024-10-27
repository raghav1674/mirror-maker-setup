# data "aws_iam_policy_document" "role_policy" {
#   for_each    = local.iam_users
#   statement {
#     effect    = "Allow"
#     actions   = [
#         "glue:GetSchemaByDefinition",
#         "glue:CreateSchema",
#         "glue:RegisterSchemaVersion",
#         "glue:PutSchemaVersionMetadata"
#     ]
#     resources = concat(
#         tolist(toset([for schema in each.value.schemas : "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:registry/${schema.schema_registry_name}"])),
#         tolist(toset([for schema in each.value.schemas : "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:schema/${schema.schema_registry_name}/${schema.schema_name}"]))
#       )
#   }
#   statement {
#     effect    = "Allow"
#     actions   = [ "glue:GetSchemaVersion"]
#     resources = ["*"]
#   }
# }



# data "aws_iam_policy_document" "user_policy" {
#   for_each    = local.iam_roles
#   statement {
#     effect    = "Allow"
#     actions   = [
#         "glue:GetSchemaByDefinition",
#         "glue:CreateSchema",
#         "glue:RegisterSchemaVersion",
#         "glue:PutSchemaVersionMetadata"
#     ]
#     resources = concat(
#         tolist(toset([for schema in each.value.schemas : "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:registry/${schema.schema_registry_name}"])),
#         tolist(toset([for schema in each.value.schemas : "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:schema/${schema.schema_registry_name}/${schema.schema_name}"]))
#       )
#   }

#   statement {
#     effect    = "Allow"
#     actions   = [ "glue:GetSchemaVersion"]
#     resources = ["*"]
#   }
# }





