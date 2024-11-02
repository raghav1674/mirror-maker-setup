resource "aws_secretsmanager_secret" "this" {
  name       = var.name
  kms_key_id = var.kms_key_id
  dynamic "replica" {
    for_each = var.replica
    content {
      kms_key_id = replica.value.kms_key_id
      region     = replica.value.region
    }
  }
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  recovery_window_in_days        = var.recovery_window_in_days
  description                    = var.description
  tags                           = var.tags
}

resource "aws_secretsmanager_secret_policy" "this" {
  count      = local.create_secret_policy
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = var.policy
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = local.create_secret_version
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
  secret_binary = var.secret_binary
}