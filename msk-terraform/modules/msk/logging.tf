resource "aws_cloudwatch_log_group" "this" {
  name              = "${var.cluster_name}-log-group"
  retention_in_days = 30
}