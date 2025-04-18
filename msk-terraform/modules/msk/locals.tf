locals {
  broker_ports = {
    9092 = "PLAINTEXT"
    9096 = "SASL_SCRAM"
    9098 = "IAM"
    9094 = "SASL_SSL"
  }

  monitoring_ports = {
    11001 = "JMX"
    11002 = "Node Exporter"
  }

  client_broker_ports = {
    9092 = "PLAINTEXT"
    9096 = "SASL_SCRAM"
    9098 = "IAM"
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
      description = local.client_broker_ports[pair[1]]
    }
  }

  kafka_version = var.kafka_version

  region     = data.aws_region.current.id
  account_id = data.aws_caller_identity.current.account_id

  create_scram_users = length(var.scram_users) > 0 ? 1 : 0

  create_cloudwatch_log_group = var.create_cloudwatch_log_group ? 1 : 0
}