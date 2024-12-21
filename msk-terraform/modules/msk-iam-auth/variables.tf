variable "role_name" {
  description = "The name of the IAM role that should be created to grant access to MSK"
  type        = string
}

variable "principal_arns" {
  description = "The ARNs of the IAM principals that should have access to assume role to access the MSK cluster"
  type        = list(string)
}

variable "msk_access_policies" {
  description = "The MSK access policies"
  type = map(list(object({
    resource_type  = string
    resource_names = list(string)
    access_type    = string
  })))
  default = {}
}

variable "additional_iam_policy" {
  description = "Additional IAM policies to grant to the role created, eg, to grant access to glue"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the IAM role"
  type        = map(string)
  default     = {}
}