module "msk-iam" {
  source = "./modules/msk-iam-access"

  msk_cluster_name = "my-msk-cluster"
  msk_cluster_arn  = "arn:aws:kafka:us-west-2:123456789012:cluster/my-msk-cluster"

  admin_iam_principals = [
    {
      principal_arn  = "arn:aws:iam::123456789012:user/tom",
      principal_type = "user"
    }
  ]

  iam_access_policies = {
    "jeff" = {
      principal_arn  = "arn:aws:iam::123456789012:user/jeff",
      principal_type = "user",
      access_policies = [
        {
          resource_type  = "Topic"
          resource_names = ["my-msk-cluster"]
          access_type    = "Read"
        }
      ]
    }
  }
}