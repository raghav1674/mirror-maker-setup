variable "kafka_connect_lb_dns" {
  description = "DNS name of the load balancer for Kafka Connect"
  type        = string
}

variable "connector_name" {
  description = "Name of the Kafka Connect connector"
  type        = string
}

variable "connector_config" {
  description = "Configuration for the Kafka Connect connector"
  type        = map(string)
}

variable "topics_to_replicate" {
  description = "List of topics to replicate"
  type        = list(string)
}

variable "num_tasks" {
  description = "Number of tasks for the connector"
  type        = number
  default     = 1
}

variable "source_cluster_config" {
  description = "Configuration for the source cluster"
  type        = map(string)
}

variable "target_cluster_config" {
  description = "Configuration for the target cluster"
  type        = map(string)
}


variable "source_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for the target cluster"
}

variable "target_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for the target cluster"
}

variable "source_secret" {
  description = "AWS Secrets Manager secret for source cluster"
  type = object({
    name = string
    key  = string
  })
  default = null
}

variable "target_secret" {
  description = "AWS Secrets Manager secret for target cluster"
  type = object({
    name = string
    key  = string
  })
  default = null
}