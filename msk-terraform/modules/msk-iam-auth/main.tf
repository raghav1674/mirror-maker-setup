data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.principal_arns
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.role_name}_MSKAssumeAccessRole"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "this" {
  for_each = var.msk_access_policies
  name     = "${each.key}_access_policy"
  role     = aws_iam_role.this.id
  policy   = module.msk_iam_access_policy_document[each.key].policy_document
}

resource "aws_iam_role_policy" "additional_access" {
  count  = var.additional_iam_policy == null ? 0 : 1
  name   = "additional_access_policy"
  role   = aws_iam_role.this.id
  policy = var.additional_iam_policy
}