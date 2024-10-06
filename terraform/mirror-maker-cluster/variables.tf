
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

variable "dd_api_key" {
  description = "Datadog Api Key"
  type        = string
  sensitive   = true
}

variable "dd_site" {
  description = "Datadog URL"
  type        = string
}

variable "additional_security_group_ids" {
  description = "Additional security group ids"
  type        = list(string)
  default     = []
}

variable "monitoring_instance" {
  description = "monitoring instance"
  type = object({
    name                 = string
    instance_type        = string
    subnet_id            = string
    source_exporter_args = map(string)
    target_exporter_args = map(string)
  })
  default = null
}

variable "associate_public_ip_address" {
  description = "Associate public IP address"
  type        = bool
  default     = false
}

variable "instance_profile_name" {
  description = "The instance profile name"
  type        = string
  default     = null
}

variable "default_tags" {
  description = "The default tags"
  type        = map(string)
  default     = {}
}