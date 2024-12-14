variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}

variable "iam_access_policies" {
  description = "The ARNs of the IAM principals that should have access to the MSK cluster"
  type = optional(map(object({
    principals = list(object({
      arns = list(string),
      type = string
    }))
    access_policies = list(object({
      resource_type  = string
      resource_names = list(string)
      access_type    = string
    }))
  })), {})
}

variable "tags" {
  description = "Tags to apply to the IAM roles"
  type        = map(string)
  default     = {}
}