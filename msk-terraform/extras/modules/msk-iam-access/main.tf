# Attach admin policy
resource "aws_iam_role_policy_attachment" "admin_roles" {
  for_each   = local.admin_roles
  role       = each.key
  policy_arn = aws_iam_policy.admin_access.arn
}

resource "aws_iam_user_policy_attachment" "admin_users" {
  for_each   = local.admin_users
  user       = each.key
  policy_arn = aws_iam_policy.admin_access.arn
}

# Attach iam access policies to roles and users
resource "aws_iam_role_policy_attachment" "iam_roles" {
  for_each   = local.iam_roles
  role       = each.value.principal_arn
  policy_arn = module.msk_iam_role_policies[each.key].policy_arn
}

resource "msk_iam_user_policies" "iam_users" {
  for_each   = local.iam_users
  user       = each.value.principal_arn
  policy_arn = module.msk_iam_user_policies[each.key].policy_arn
}