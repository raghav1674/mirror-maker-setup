resource "aws_msk_configuration" "this" {
  kafka_versions    = [local.kafka_version]
  name              = "${var.cluster_name}-${local.version}-config"
  server_properties = var.broker_configuration
}

locals {
  version = replace(local.kafka_version, ".", "-")
}