variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}

variable "assume_role_name" {
  description = "The name of the IAM role that should be created to assume role to access the MSK cluster"
  type        = string
}

variable "principal_arns" {
  description = "The ARNs of the IAM principals that should have access to assume role to access the MSK cluster"
  type        = list(string)
}

variable "access_policies" {
  description = "The MSK access policies"
  type = list(object({
    resource_type  = string
    resource_names = list(string)
    access_type    = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the IAM roles"
  type        = map(string)
  default     = {}
}