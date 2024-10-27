# resource "aws_appautoscaling_target" "this" {
#   max_capacity       = var.broker_max_volume_size
#   min_capacity       = var.broker_volume_size
#   resource_id        = aws_msk_cluster.this[0].arn
#   scalable_dimension = "kafka:broker-storage:VolumeSize"
#   service_namespace  = "kafka"
# }

# resource "aws_appautoscaling_policy" "this" {
#   name               = "${var.cluster_name}-broker-storage-scaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_msk_cluster.this.arn
#   scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.this.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "KafkaBrokerStorageUtilization"
#     }

#     target_value = 60
#   }
# }