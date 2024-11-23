resource "aws_msk_cluster" "this" {
  cluster_name           = var.cluster_name
  kafka_version          = local.kafka_version
  number_of_broker_nodes = var.number_of_brokers

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }

  broker_node_group_info {
    instance_type  = var.broker_instance_type
    client_subnets = var.broker_subnets

    # connectivity_info {
    #   vpc_connectivity {
    #     dynamic "client_authentication" {
    #       for_each = var.client_authentication == null ? [] : [1]
    #       content {
    #         dynamic "sasl" {
    #           for_each = try([var.client_authentication.value.sasl], [])
    #           content {
    #             iam   = try(sasl.value.iam, null)
    #             scram = try(sasl.value.scram, null)
    #           }
    #         }
    #         tls = try(var.client_authentication.value.tls, null)
    #       }
    #     }
    #   }
    # }

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }
    security_groups = [
      aws_security_group.internal.id,
      aws_security_group.monitoring.id,
      aws_security_group.external.id,
      aws_security_group.additional.id
    ]
  }

  dynamic "client_authentication" {
    for_each = var.client_authentication == null ? [] : [1]
    content {
      dynamic "sasl" {
        for_each = try([var.client_authentication.sasl], [])

        content {
          iam   = try(sasl.value.iam, null)
          scram = try(sasl.value.scram, null)
        }
      }
      unauthenticated = try(var.client_authentication.unauthenticated, null)
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  dynamic "open_monitoring" {
    for_each = var.open_monitoring_enabled ? [1] : []
    content {
      prometheus {
        jmx_exporter {
          enabled_in_broker = true
        }
        node_exporter {
          enabled_in_broker = true
        }
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = local.create_cloudwatch_log_group
        log_group = try(aws_cloudwatch_log_group.this[0].name, null)
      }
    }
  }

  # required for appautoscaling
  # lifecycle {
  #   ignore_changes = [
  #     broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
  #   ]
  # }

  tags = var.tags
}
