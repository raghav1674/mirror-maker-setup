data "aws_iam_policy_document" "msk_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.principal_arns
    }
  }
}

resource "aws_iam_role" "assume_role" {
  name               = "${var.assume_role_name}_MSKAssumeAccessRole"
  assume_role_policy = data.aws_iam_policy_document.msk_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "assume_role_policy" {
  name   = "${var.assume_role_name}_MSKAccessPolicy"
  role   = aws_iam_role.assume_role.name
  policy = module.msk_iam_access_policy.policy_document
}
