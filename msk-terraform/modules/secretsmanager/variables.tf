variable "name" {
  description = "The name of the secret"
  type        = string
}

variable "kms_key_id" {
  description = "The ARN of the KMS key to use to encrypt the secret"
  type        = string
  default     = null
}

variable "replica" {
  description = "Replica secret configuration"
  type = list(object({
    kms_key_id = string
    region     = string
  }))
  default = []
}

variable "force_overwrite_replica_secret" {
  description = "Specifies whether to force overwrite replica secret name in the destination"
  type        = bool
  default     = false
}

variable "recovery_window_in_days" {
  description = "The number of days until the secret is deleted after deletion is requested"
  type        = number
  default     = 7
}

variable "policy" {
  description = "A JSON policy document that controls access to this secret"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the secret"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the secret"
  type        = map(string)
  default     = {}
}

variable "secret_string" {
  description = "The plaintext data of the secret"
  type        = string
  default     = null
}

variable "secret_binary" {
  description = "The binary data of the secret"
  type        = string
  default     = null
}