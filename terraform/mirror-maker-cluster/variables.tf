
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "ssh_key_name" {
  description = "The key pair name"
  type        = string
}

variable "bootstrap_servers" {
  description = "destination kafka bootstrap servers"
  type        = string
}

variable "cluster_suffix" {
  description = "The suffix for the cluster"
  type        = string
}

variable "connect_instances" {
  description = "The list of Kafka Connect instances"
  type = list(object({
    name          = string
    instance_type = string
    subnet_id     = string
  }))
}

variable "kafka_connect_properties" {
  description = "The Kafka Connect properties"
  type        = map(string)
  default     = {}
}