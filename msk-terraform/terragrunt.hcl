locals {
  input_vars       = read_terragrunt_config("inputs.hcl")
  config_vars      = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
  component_name   = "${basename(path_relative_to_include())}"
  region_name      = "${basename(dirname(path_relative_to_include()))}"
  
  config_overrides = try(read_terragrunt_config("config-overrides.hcl").inputs, {})
  module_name      = try(local.config_overrides.module_name, local.component_name)
}

# Generate the provider block
generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_name}"
  default_tags {
    tags = ${jsonencode(local.config_vars.tags)}
  }
}
EOF
}

# Generate the backend block
# remote_state {
#   backend = "s3"
#   generate = {
#     path      = "_backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
#   config = {
#     bucket         = "${local.config_vars.remote_state_bucket}"

#     key            = "${local.config_vars.remote_state_basename}/${local.region_name}/${local.component_name}/terraform.tfstate"
#     region         = "${local.config_vars.region}"
#     encrypt        = true
#     dynamodb_table = "${local.config_vars.dynamodb_table}"
#   }
# }

remote_state {
  backend = "local"
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${get_parent_terragrunt_dir()}/states/${local.config_vars.remote_state_basename}/${local.region_name}/${local.component_name}/terraform.tfstate"
  }
}

# Include the Terraform configuration
terraform {
  source = "${get_parent_terragrunt_dir()}/modules//${local.module_name}"
}

# Include the inputs from the child inputs.hcl file
inputs = local.input_vars.inputs