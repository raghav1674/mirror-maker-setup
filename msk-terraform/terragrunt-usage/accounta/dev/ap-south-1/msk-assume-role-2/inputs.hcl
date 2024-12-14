inputs = {
  msk_cluster_name = "msk-cluster"
  assume_role_name = "msk-assume-role"
  principal_arns   = ["arn:aws:iam::123456789012:role/role1", "arn:aws:iam::123456789012:role/role2"]
  access_policies = [
    {
      resource_type  = "Topic"
      resource_names = ["test"]
      access_type    = "Read"
    },
    {
      resource_type  = "Group"
      resource_names = ["test"]
      access_type    = "Read"
    },
    {
      resource_type  = "Topic"
      resource_names = ["test"]
      access_type    = "Write"
    },
    {
      resource_type  = "TransactionalId"
      resource_names = ["test"]
      access_type    = "Write"
    }
  ]
}