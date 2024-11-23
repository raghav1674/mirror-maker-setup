locals {
  schemas    = { for schema in var.schemas : schema.schema_name => aws_glue_schema.this[schema.schema_name].arn }
  registries = { for schema_registry in var.schema_registries : schema_registry.name => aws_glue_registry.this[schema_registry.name].arn }
}


locals {
  region     = data.aws_region.current.id
  account_id = data.aws_caller_identity.current.account_id
}

