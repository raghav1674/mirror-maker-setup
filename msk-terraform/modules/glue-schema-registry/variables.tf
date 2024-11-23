variable "schema_registry_name" {
  type        = string
  description = "Name for the schema registry"
}

variable "schema_registry_description" {
  type        = string
  description = "Description for the schema registry"
  default     = null
}

variable "schema_registry_assume_role_name" {
  type        = string
  description = "Name of the assume role to be created for glue schema registry access, defaults to 'registry_name_GlueSchemaAccessRole"
  default     = null
}

variable "account_ids" {
  type        = list(string)
  description = "Ids of the account ids to allow cross account access to"
  default     = []
}


variable "prinicipal_arns" {
  type        = list(string)
  description = "List of prinicipals to allow access to schema registry"
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

