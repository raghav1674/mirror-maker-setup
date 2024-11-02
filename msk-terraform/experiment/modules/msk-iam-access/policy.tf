# MSK Admin policy
data "aws_iam_policy_document" "admin_policy" {
  statement {
    effect    = "Allow"
    actions   = ["kafka-cluster:*"]
    resources = ["${local.msk_cluster_arn}:cluster/${var.msk_cluster_name}/*"]
  }
}

resource "aws_iam_policy" "admin_access" {
  name        = "${var.msk_cluster_name}-admin-access"
  path        = "/"
  description = "IAM policy for admin access to the MSK cluster"
  policy      = aws_iam_policy_document.admin_policy.json
}

# IAM Role MSK Access Policies
module "msk_iam_role_policies" {
  for_each = local.admin_roles

  source           = "./msk-iam-policy"
  principal_name   = each.key
  msk_cluster_name = var.msk_cluster_name
  msk_cluster_arn  = local.msk_cluster_arn
  access_policies  = each.value.access_policies
}

# IAM User MSK Access Policies
module "msk_iam_user_policies" {
  for_each = local.admin_users

  source           = "./msk-iam-policy"
  principal_name   = each.key
  msk_cluster_name = var.msk_cluster_name
  msk_cluster_arn  = local.msk_cluster_arn
  access_policies  = each.value.access_policies
}