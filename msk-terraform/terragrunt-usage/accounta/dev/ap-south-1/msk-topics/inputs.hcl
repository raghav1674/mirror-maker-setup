inputs = {
  msk_cluster_name = "msk-cluster"
  topics = {
    "topic1" = {
      replication_factor = 3
      partitions         = 1
      config = {
        "cleanup.policy" = "compact"
      }
    }
    "topic2" = {
      replication_factor = 3
      partitions         = 1
      config = {
        "cleanup.policy" = "delete"
      }
    }
  }
}