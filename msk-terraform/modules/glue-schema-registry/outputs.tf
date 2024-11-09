output "registry_arns" {
  value = { for  name,registry in aws_glue_registry.this : name => registry.arn }
}

output "schema_arns" {
  value = { for name,schema in aws_glue_schema.this : name => schema.arn }
}

output "cross_account_roles" {
  value = { for name,role in aws_iam_role.glue_cross_account_role : name => role.arn }
}