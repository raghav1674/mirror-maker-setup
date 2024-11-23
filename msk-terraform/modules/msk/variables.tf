variable "vpc_id" {
  type        = string
  description = "The VPC ID to place the MSK cluster in"

}

variable "broker_subnets" {
  type        = list(string)
  description = "The subnets to place the broker nodes in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the MSK cluster"
}

variable "kafka_version" {
  type        = string
  description = "The version of Apache Kafka"
}

variable "broker_configuration" {
  type        = string
  description = "The configuration of the broker nodes"
}

variable "number_of_brokers" {
  type        = number
  description = "The number of broker nodes in the Kafka cluster"
  default     = 1
}

variable "broker_instance_type" {
  type        = string
  description = "The instance type of the broker nodes"
  default     = "kafka.m5.large"
}

variable "broker_volume_size" {
  type        = number
  description = "The size in GB of the EBS volume for the broker nodes"
}

variable "broker_max_volume_size" {
  type        = number
  description = "The maximum size in GB of the EBS volume for the broker nodes"
  default     = 1000
}

variable "enable_storage_autoscaling" {
  type        = bool
  description = "Indicates whether you want to enable or disable storage autoscaling for the broker nodes"
  default     = false
}

variable "client_authentication" {
  type        = any
  description = "The authentication method used to access the Kafka cluster"
}


variable "open_monitoring_enabled" {
  type        = bool
  description = "Indicates whether you want to enable or disable the open monitoring for the MSK cluster"
  default     = false
}

variable "client_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks to allow client connections from"
  default     = []
}

variable "monitoring_cidr_blocks" {
  type        = list(string)
  description = "The CIDR blocks to allow monitoring connections from"
  default     = []
}

variable "scram_users" {
  type = list(object({
    username = string
  }))
  description = "The list of SCRAM users to create"
  default     = []
}

variable "create_cloudwatch_log_group" {
  type        = bool
  description = "Indicates whether you want to create a CloudWatch log group for the MSK cluster"
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
