output "registry_arn" {
  value = aws_glue_registry.this.arn
}

output "glue_assume_role_arn" {
  value = aws_iam_role.glue_cross_account_role.arn
}