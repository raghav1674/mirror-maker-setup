resource "aws_cloudwatch_log_group" "this" {
  count             = local.create_cloudwatch_log_group
  name              = "${var.cluster_name}-log-group"
  retention_in_days = 30
}