locals {
  schemas    = { for schema in var.schemas : schema.schema_name => aws_glue_schema.this[schema.schema_name].arn }
  registries = { for schema_registry in var.schema_registries : schema_registry.name => aws_glue_registry.this[schema_registry.name].arn }
}

# locals {
#     iam_users = { for principal in var.access_policies : principal.arn => principal if principal.principal_type == "user" }
#     iam_roles = { for principal in var.access_policies : principal.arn => principal if principal.principal_type == "role" }
# }