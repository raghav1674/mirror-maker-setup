resource "aws_msk_configuration" "this" {
  kafka_versions    = [local.kafka_version]
  name              = "${var.cluster_name}-${local.version}-config-${local.configsha}"
  server_properties = var.broker_configuration

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  configsha = substr(sha256(var.broker_configuration), 0, 4)
  version   = replace(local.kafka_version, ".", "-")
}