resource "kafka_topic" "this" {
  for_each           = var.topics
  name               = each.key
  replication_factor = each.value.replication_factor
  partitions         = each.value.partitions
  config             = each.value.config
}