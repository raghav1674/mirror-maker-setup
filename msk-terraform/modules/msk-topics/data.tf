data "aws_msk_cluster" "this" {
  cluster_name = var.msk_cluster_name
}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}