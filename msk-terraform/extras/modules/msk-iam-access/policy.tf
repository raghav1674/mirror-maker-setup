module "msk_iam_access_policies" {
  for_each = var.iam_access_policies

  source = "./msk-iam-policy"

  msk_cluster_account_id = data.aws_caller_identity.current.account_id
  msk_cluster_name       = var.msk_cluster_name
  msk_cluster_region     = data.aws_region.current.name
  access_policies        = each.value.access_policies
}