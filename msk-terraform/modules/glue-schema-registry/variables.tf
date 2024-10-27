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

# variable "access_policies" {
#   type = list(object({
#     principal_arn        = string
#     principal_type       = string
#     schemas              = list(object({
#       schema_registry_name = string
#       schema_name          = string
#     }))
#   }))
# }