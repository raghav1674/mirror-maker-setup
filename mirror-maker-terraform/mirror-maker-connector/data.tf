data "aws_secretsmanager_secret" "source" {
  count = var.source_secret != null ? 1 : 0
  name  = var.source_secret.name
}

data "aws_secretsmanager_secret_version" "source" {
  count     = var.source_secret != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.source[0].id
}

data "aws_secretsmanager_secret" "target" {
  count    = var.target_secret != null ? 1 : 0
  name     = var.target_secret.name
}

data "aws_secretsmanager_secret_version" "target" {
  count     = var.target_secret != null ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.target[0].id
}

