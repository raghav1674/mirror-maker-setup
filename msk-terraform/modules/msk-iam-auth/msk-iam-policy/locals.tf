locals {
  msk_arn_prefix = "arn:aws:kafka:${var.msk_cluster_region}:${var.msk_cluster_account_id}"
}

locals {
  read_topics        = flatten([for policy in var.access_policies : policy.resource_names if policy.access_type == "Read" && policy.resource_type == "Topic"])
  write_topics       = flatten([for policy in var.access_policies : policy.resource_names if policy.access_type == "Write" && policy.resource_type == "Topic"])
  write_transactions = flatten([for policy in var.access_policies : policy.resource_names if policy.access_type == "Write" && policy.resource_type == "TransactionalId"])
  write_groups       = flatten([for policy in var.access_policies : policy.resource_names if policy.access_type == "Write" && policy.resource_type == "Group"])
}
