data "aws_iam_policy_document" "msk_assume_role_policy" {
  for_each = var.iam_access_policies
  statement {
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = each.value.principals
      content {
        type        = principals.value.type
        identifiers = principals.value.arns
      }
    }
  }
}

resource "aws_iam_role" "assume_role" {
  for_each           = var.iam_access_policies
  name               = "${each.key}_MSKAssumeAccessRole"
  assume_role_policy = data.aws_iam_policy_document.msk_assume_role_policy[each.key].json
  tags               = var.tags
}

resource "aws_iam_role_policy" "admin_policy" {
  for_each = var.iam_access_policies
  name     = "${each.key}_MSKAccessPolicy"
  role     = aws_iam_role.assume_role[each.key].name
  policy   = module.msk_iam_access_policies[each.key].policy_document
}
