output "bootstrap_brokers" {
  value = {
    "SASL_IAM"   = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
    "SASL_SCRAM" = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
  }
}

output "security_group_ids" {
  value = {
    "internal"   = aws_security_group.internal.id
    "monitoring" = aws_security_group.monitoring.id
    "external"   = [aws_security_group.external.id, aws_security_group.additional.id]
  }
}

output "scram_users" {
  value = { for username,secret in module.secrets : username => secret.arn }
}

output "secretsmanager_kms_key_id" {
  value = try(aws_kms_key.this[0].key_id, null)
}