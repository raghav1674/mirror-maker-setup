variable "msk_cluster_name" {
  description = "The name of the MSK cluster"
  type        = string
}

variable "topics" {
  description = "A map of topics to create"
  type = map(object({
    replication_factor = number
    partitions         = number
    config             = map(string)
  }))
}