locals {
  broker_ports = {
    9092 = "PLAINTEXT"
    9096 = "TLS"
    9098 = "SASL_PLAINTEXT"
    9094 = "SASL_SSL"
  }

  monitoring_ports = {
    11001 = "JMX"
    11002 = "Node Exporter"
  }

  client_broker_ports = {
    9092 = "PLAINTEXT"
    9096 = "TLS"
    9098 = "SASL_PLAINTEXT"
    9094 = "SASL_SSL"
  }

  monitoring_rules = {
    for pair in setproduct(var.monitoring_cidr_blocks, keys(local.monitoring_ports)) : format("%s_%s", pair[0], pair[1]) => {
      cidr_ipv4   = pair[0]
      port        = pair[1]
      description = local.monitoring_ports[pair[1]]
    }
  }

  client_broker_rules = {
    for pair in setproduct(var.client_cidr_blocks, keys(local.client_broker_ports)) : format("%s_%s", pair[0], pair[1]) => {
      cidr_ipv4   = pair[0]
      port        = pair[1]
      description = local.monitoring_ports[pair[1]]
    }
  }

  kafka_version = var.kraft_enabled ? "${var.kafka_version}.kraft" : var.kafka_version
}