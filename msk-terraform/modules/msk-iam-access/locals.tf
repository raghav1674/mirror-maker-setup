locals {
  admin_users = { for user in var.admin_iam_principals : user.principal_arn => user if user.principal_type == "user" }
  admin_roles = { for role in var.admin_iam_principals : role.principal_arn => role if role.principal_type == "role" }

  iam_users = { for user_name, user in var.iam_access_policies : user_name => user if user.principal_type == "user" }
  iam_roles = { for role_name, role in var.iam_access_policies : role_name => role if role.principal_type == "role" }
}

locals {
  msk_cluster_arn = "arn:aws:kafka:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:cluster/${var.msk_cluster_name}"
}

