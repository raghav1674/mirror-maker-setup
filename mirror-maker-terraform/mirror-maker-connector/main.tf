locals {
  config_sensitive = {
    "source.cluster.sasl.jaas.config" = var.source_secret != null ? "org.apache.kafka.common.security.scram.ScramLoginModule required  username=\"${var.source_secret.key}\" password=\"${local.source_secret_value}\" ; " : null
    "target.cluster.sasl.jaas.config" = var.target_secret != null ? "org.apache.kafka.common.security.scram.ScramLoginModule required  username=\"${var.target_secret.key}\" password=\"${local.target_secret_value}\" ; " : null
  }
}

resource "kafka-connect_connector" "source_connector" {
  name = var.connector_name

  config = merge(templatefile("connector-configs/source-connector-config.json.tfpl", {
    name = var.connector_name
    num_tasks = var.num_tasks
    topics = var.topics_to_replicate
    target_cluster_config = var.target_cluster_config
    source_cluster_config = var.source_cluster_config
  }), var.connector_config)

  config_sensitive = local.config_sensitive
}