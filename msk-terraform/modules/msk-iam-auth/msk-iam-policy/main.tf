data "aws_iam_policy_document" "access_policy" {
  statement {
    sid    = "AllowMskClusterAccess"
    effect = "Allow"
    actions = [
      "kafka-cluster:Connect",
      "kafka-cluster:DescribeCluster",
      "kafka-cluster:DescribeClusterDynamicConfiguration"
    ]
    resources = ["${local.msk_arn_prefix}:cluster/${var.msk_cluster_name}/*"]
  }

  dynamic "statement" {
    for_each = length(local.read_topics) > 0 ? [1] : []
    content {
      sid    = "AllowReadTopicAccess"
      effect = "Allow"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:ReadData"
      ]
      resources = [for topic in local.read_topics : "${local.msk_arn_prefix}:topic/${var.msk_cluster_name}/*/${topic}"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_groups) > 0 ? [1] : []
    content {
      sid    = "AllowConsumerGroupAccess"
      effect = "Allow"
      actions = [
        "kafka-cluster:DescribeGroup",
        "kafka-cluster:AlterGroup",
        "kafka-cluster:DeleteGroup"
      ]
      resources = [for consumer_group in local.write_groups : "${local.msk_arn_prefix}:group/${var.msk_cluster_name}/*/${consumer_group}"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_topics) > 0 ? [1] : []
    content {
      sid    = "AllowTopicWriteAccess"
      effect = "Allow"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:WriteData",
        "kafka-cluster:AlterTopic",
        "kafka-cluster:DescribeTopicDynamicConfiguration",
        "kafka-cluster:AlterTopicDynamicConfiguration",
        "kafka-cluster:CreateTopic",
        "kafka-cluster:DeleteTopic"
      ]
      resources = [for topic in local.write_topics : "${local.msk_arn_prefix}:topic/${var.msk_cluster_name}/*/${topic}"]

    }
  }
  dynamic "statement" {
    for_each = length(local.write_topics) > 0 ? [1] : []
    content {
      sid    = "AllowTopicWriteDataIdempotentAccess"
      effect = "Allow"
      actions = [
        "kafka-cluster:WriteDataIdempotently"
      ]
      resources = ["${local.msk_arn_prefix}:cluster/${var.msk_cluster_name}/*"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_transactions) > 0 ? [1] : []
    content {
      sid    = "AllowTransactionalIdWriteAccess"
      effect = "Allow"
      actions = [
        "kafka-cluster:DescribeTransactionalId",
        "kafka-cluster:AlterTransactionalId"
      ]
      resources = [for transactional_id in local.write_transactions : "${local.msk_arn_prefix}:transactional-id/${var.msk_cluster_name}/*/${transactional_id}"]
    }
  }
}