inputs = {
  schema_registries = [
    {
      name        = "test-registry"
      description = "Test registry"
    }
  ]

  schemas = [
    # {
    #   schema_registry_name = "test-registry"
    #   schema_name          = "test-schema"
    #   description          = "Test schema"
    #   schema_definition    = "schema-definition"
    # }
  ]

  cross_account_access = {
    test_role = {
      # prinicipal_arns   = "arn:aws:iam::123456789012:role/test-role"
      account_id = "12345689012"
      registries = ["test-registry"]
      policy_conditions = [
        {
          test     = "StringEquals"
          variable = "aws:userid"
          values   = ["12345689012"]
        }
      ]
    }
  }

}