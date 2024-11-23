resource "aws_glue_registry" "this" {
  registry_name = var.schema_registry_name
  description   = var.schema_registry_description
  tags          = var.tags
}
