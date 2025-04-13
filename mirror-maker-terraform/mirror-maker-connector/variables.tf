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