resource "aws_glue_registry" "this" {
  for_each      = { for schema_registry in var.schema_registries : schema_registry.name => schema_registry }
  registry_name = each.key
  description   = each.value.description
  tags          = var.tags
}

resource "aws_glue_schema" "this" {
  for_each = { for schema in var.schemas : schema.schema_name => schema }

  schema_name       = each.key
  description       = each.value.description
  registry_arn      = aws_glue_registry.this[each.value.schema_registry_name].arn
  data_format       = each.value.data_format
  compatibility     = each.value.compatibility
  schema_definition = each.value.schema_definition

  tags = var.tags
}

