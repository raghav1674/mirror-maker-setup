variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}


variable "admin_iam_principals" {
  description = "The ARNs of the IAM principals that should have admin access to the MSK cluster"
  type = list(object({
    principal_arn  = string
    principal_type = string
  }))
}

variable "iam_access_policies" {
  description = "The ARNs of the IAM principals that should have access to the MSK cluster"
  type = optional(map(object({
    principal_arn  = string,
    principal_type = string
    access_policies = list(object({
      resource_type  = string
      resource_names = list(string)
      access_type    = string
    }))
  })), {})
}