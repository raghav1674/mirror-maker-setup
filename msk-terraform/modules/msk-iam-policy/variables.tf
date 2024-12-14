variable "msk_cluster_name" {
  description = "The Name of the MSK cluster"
  type        = string
}

variable "msk_cluster_region" {
  description = "The region of the MSK cluster"
  type        = string
}

variable "msk_cluster_account_id" {
  description = "The  account id of the MSK cluster"
  type        = string
}

/* 
  Similar to Kafka ACLs, MSK IAM policies are used to control access to resources in MSK.

  resource_type: The type of resource to which the policy applies. Topic, Group and TransactionalId
  resource_names: The names of the resources to which the policy applies, e.g. ["topic1", "topic2"]
  access_type: The type of access to grant. Read or Write

  supported access_type and resource_type combinations:
    - Read Topic
    - Write Topic
    - Write TransactionalId
    - Read Group

    eg. 
     access_policies = [
      // Read from topic1 and topic2
      {
        resource_type  = "Topic"
        resource_names = ["topic1", "topic2"]
        access_type    = "Read"
      },
      // Write to topic1 and topic2
      {
        resource_type  = "Topic"
        resource_names = ["topic1", "topic2"]
        access_type    = "Write"
      },
      // Use transactionalId1 and transactionalId2
      {
        resource_type  = "TransactionalId"
        resource_names = ["transactionalId1", "transactionalId2"]
        access_type    = "Write"
      },
      // Create consumer group names as  group1 and group2
      {
        resource_type  = "Group"
        resource_names = ["group1", "group2"]
        access_type    = "Read"
      }
    ]
*/

variable "access_policies" {
  description = "The msk iam access policies for the principal"
  type = list(object({
    resource_type  = string
    resource_names = list(string)
    access_type    = string
  }))
}