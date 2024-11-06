output "arn" {
  value = aws_secretsmanager_secret.this.arn
}

output "vesion_id" {
  value = local.create_secret_version == 1 ? aws_secretsmanager_secret_version.this[0].version_id : null
}



