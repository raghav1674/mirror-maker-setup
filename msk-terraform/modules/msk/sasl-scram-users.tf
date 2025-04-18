resource "aws_kms_key" "this" {
  count                    = local.create_scram_users
  description              = "Kms key for Secret Used by MSK"
  enable_key_rotation      = true
  deletion_window_in_days  = 7
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  tags                     = var.tags
}

# https://repost.aws/questions/QU-l9TBiKvR0a_Io98aeptHg/minimal-privilege-msk-scram-kms-key-policy
data "aws_iam_policy_document" "this" {
  statement {
    sid = "DefaultKeyPolicy"

    actions = [
      "kms:*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [local.account_id]
    }
  }

  statement {
    sid = "AllowUseOfTheKeyForSecretsManagerFromMSK"

    principals {
      type        = "Service"
      identifiers = ["kafka.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:SecretARN"
      values   = ["arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:AmazonMSK_*"]
    }
  }
}

resource "aws_kms_key_policy" "this" {
  count  = local.create_scram_users
  key_id = aws_kms_key.this[0].id
  policy = data.aws_iam_policy_document.this.json
}

resource "random_password" "sasl_password" {
  for_each         = { for user in var.scram_users : user.username => user }
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  sasl_scram_users_with_password = { for user in var.scram_users : "AmazonMSK_${user.username}" => { username = user.username, password = random_password.sasl_password[user.username].result } }
}


module "secrets" {
  for_each                = local.sasl_scram_users_with_password
  source                  = "../secretsmanager"
  kms_key_id              = aws_kms_key.this[0].key_id
  name                    = each.key
  recovery_window_in_days = 7
  secret_string           = jsonencode(each.value)
  tags                    = var.tags
}

resource "aws_msk_scram_secret_association" "this" {
  count           = local.create_scram_users
  cluster_arn     = aws_msk_cluster.this.arn
  secret_arn_list = [for secret in module.secrets : secret.arn]
  depends_on      = [module.secrets]
}


