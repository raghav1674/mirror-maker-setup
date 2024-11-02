locals {
  create_secret_version = var.secret_string != null || var.secret_binary != null ? 1 : 0
  create_secret_policy  = var.policy != null ? 1 : 0
}