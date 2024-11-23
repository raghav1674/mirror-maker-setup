locals {
  read_topics        = flatten([for policy in var.iam_principals_access.roles : resource_names if policy.access_type == "Read" && policy.resource_type == "Topic"])
  write_topics       = flatten([for policy in var.iam_principals_access.roles : resource_names if policy.access_type == "Write" && policy.resource_type == "Topic"])
  write_transactions = flatten([for policy in var.iam_principals_access.roles : resource_names if policy.access_type == "Write" && policy.resource_type == "TransactionalId"])
  read_groups        = flatten([for policy in var.iam_principals_access.roles : resource_names if policy.access_type == "Read" && policy.resource_type == "Group"])
}


data "aws_iam_policy_document" "access_policy" {
  statement {
    effect    = "AllowMskClusterAccess"
    actions   = ["kafka-cluster:Connect"]
    resources = ["${var.msk_cluster_arn}:cluster/${var.msk_cluster_name}/*"]
  }

  dynamic "statement" {
    for_each = length(local.read_topics) > 0 ? [1] : []
    content {
      effect = "AllowReadTopicAccess"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:ReadData"
      ]
      resources = [for topic in local.read_topics : "${var.msk_cluster_arn}:topic/${var.msk_cluster_name}/*/${topic.topic_name}"]

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
      resources = [for consumer_group in local.read_groups : "${var.msk_cluster_arn}:group/${var.msk_cluster_name}/*/${consumer_group.consumer_group_name}"]

    }
  }

  dynamic "statement" {
    for_each = length(local.write_topics) > 0 ? [1] : []
    content {
      effect = "AllowTopicWriteAccess"
      actions = [
        "kafka-cluster:DescribeTopic",
        "kafka-cluster:WriteData",
        "kafka-cluster:WriteDataIdempotently",
        "kafka-cluster:AlterTopic",
        "kafka-cluster:DescribeTopicDynamicConfiguration",
        "kafka-cluster:AlterTopicDynamicConfiguration",
        "kafka-cluster:CreateTopic"
      ]
      resources = [for topic in local.write_topics : "${var.msk_cluster_arn}:topic/${var.msk_cluster_name}/*/${topic.topic_name}"]

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
      resources = [for transactional_id in local.write_transactions : "${var.msk_cluster_arn}:transactional-id/${var.msk_cluster_name}/*/${transactional_id.transactional_id}"]
    }
  }
}

resource "aws_iam_policy" "iam_access" {
  name        = "${var.msk_cluster_name}-${var.principal_name}-iam-access"
  path        = "/"
  description = "IAM policy for admin access to the MSK cluster"
  policy      = data.aws_iam_policy_document.access_policy.json
}