output "registry_arns" {
  value = { for  registry in aws_glue_registry.this : registry.key => registry.arn }
}

output "schema_arns" {
  value = { for schema in aws_glue_schema.this : schema.key => schema.arn }
}

output "cross_account_roles" {
  value = { for role in aws_iam_role.glue_cross_account_role : role.key => role.arn }
}