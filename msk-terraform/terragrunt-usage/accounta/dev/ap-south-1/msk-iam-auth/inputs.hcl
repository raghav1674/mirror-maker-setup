inputs = {
  role_name      = "msk-assume-role"
  principal_arns = [""]
  additional_iam_policy = file("policies/additional_policy.json")
  msk_access_policies = {
    "msk-cluster" = [
      {
        resource_type  = "Topic"
        resource_names = ["test"]
        access_type    = "Read"
      },
      {
        resource_type  = "Group"
        resource_names = ["test"]
        access_type    = "Write"
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
    "msk-cluster-2" = [
      {
        resource_type  = "Topic"
        resource_names = ["test"]
        access_type    = "Read"
      },
      {
        resource_type  = "Group"
        resource_names = ["test"]
        access_type    = "Write"
      }
    ]
  }
}