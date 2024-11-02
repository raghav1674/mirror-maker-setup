variable "schema_registries" {
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "schemas" {
  type = list(object({
    schema_registry_name = string
    schema_name          = string
    description          = string
    data_format          = optional(string, "AVRO")
    compatibility        = optional(string, "BACKWARD")
    schema_definition    = string
  }))
  default = []
}

variable "cross_account_access" {
  type = map(object({
    prinicipal_arns = optional(list(string), [])
    account_id      = string
    schemas         = list(string)
    registries      = list(string)
    policy_conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })), [])
  }))
  default = {}
}