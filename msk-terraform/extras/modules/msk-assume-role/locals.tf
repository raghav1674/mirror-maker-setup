locals {
  msk_arn_prefix = "arn:aws:kafka:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}"
}
