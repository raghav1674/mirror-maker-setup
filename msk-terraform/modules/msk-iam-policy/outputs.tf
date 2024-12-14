output "policy_document" {
  value = data.aws_iam_policy_document.access_policy.json
}