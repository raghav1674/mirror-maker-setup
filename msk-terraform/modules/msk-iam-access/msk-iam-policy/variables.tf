variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}

variable "msk_cluster_arn" {
  description = "The ARN of the MSK cluster"
  type        = string
}

variable "principal_name" {
  type        = string
  description = "The name of the principal"
}

variable "access_policies" {
  description = "The msk iam access policies for the principal"
  type = list(object({
    resource_type  = string
    resource_names = list(string)
    access_type    = string
  }))
}