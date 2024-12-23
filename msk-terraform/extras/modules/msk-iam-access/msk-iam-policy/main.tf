data "aws_iam_policy_document" "access_policy" {
  statement {
    effect    = "AllowMskClusterAccess"
    actions   = ["kafka-cluster:Connect"]
    resources = ["${local.msk_arn_prefix}:cluster/${var.msk_cluster_name}/*"]
  }

  dynamic "statement" {
    for_each = length(local.read_topics) > 0 ? [1] : []
    content {
      effect = "AllowReadTopicAccess"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:ReadData"
      ]
      resources = [for topic in local.read_topics : "${local.msk_arn_prefix}:topic/${var.msk_cluster_name}/*/${topic.topic_name}"]

    }
  }

  dynamic "statement" {
    for_each = length(local.read_groups) > 0 ? [1] : []
    content {
      effect = "AllowConsumerGroupAccess"
      actions = [
        "kafka-cluster:DescribeGroup",
        "kafka-cluster:AlterGroup",
        "kafka-cluster:DeleteGroup"
      ]
      resources = [for consumer_group in local.read_groups : "${local.msk_arn_prefix}:group/${var.msk_cluster_name}/*/${consumer_group.consumer_group_name}"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_topics) > 0 ? [1] : []
    content {
      effect = "AllowTopicWriteAccess"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:WriteData",
        "kafka-cluster:AlterTopic",
        "kafka-cluster:DescribeTopicDynamicConfiguration",
        "kafka-cluster:AlterTopicDynamicConfiguration",
        "kafka-cluster:CreateTopic"
      ]
      resources = [for topic in local.write_topics : "${local.msk_arn_prefix}:topic/${var.msk_cluster_name}/*/${topic.topic_name}"]

    }
  }
  dynamic "statement" {
    for_each = length(local.write_topics) > 0 ? [1] : []
    content {
      effect = "AllowTopicWriteDataIdempotentAccess"
      actions = [
        "kafka-cluster:WriteDataIdempotently"
      ]
      resources = ["${local.msk_arn_prefix}:cluster/${var.msk_cluster_name}/*"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_transactions) > 0 ? [1] : []
    content {
      effect = "AllowTransactionalIdWriteAccess"
      actions = [
        "kafka-cluster:DescribeTransactionalId",
        "kafka-cluster:AlterTransactionalId"
      ]
      resources = [for transactional_id in local.write_transactions : "${local.msk_arn_prefix}:transactional-id/${var.msk_cluster_name}/*/${transactional_id.transactional_id}"]
    }
  }
}