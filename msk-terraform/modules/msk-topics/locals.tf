locals {
  bootstrap_servers = split(",", data.aws_msk_cluster.this.bootstrap_brokers_sasl_iam)
  region_name       = data.aws_region.current.name
  account_id        = data.aws_caller_identity.current.account_id
}