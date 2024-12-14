variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}

variable "msk_cluster_region" {
  description = "The region of the MSK cluster"
  type        = string
}

variable "msk_cluster_account_id" {
  description = "The  account id of the MSK cluster"
  type        = string
}

variable "access_policies" {
  description = "The msk iam access policies for the principal"
  type = list(object({
    resource_type  = string
    resource_names = list(string)
    access_type    = string
  }))
}