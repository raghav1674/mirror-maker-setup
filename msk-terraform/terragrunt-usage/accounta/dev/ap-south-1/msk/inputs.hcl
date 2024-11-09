inputs = {
  source                     = "../modules/msk"
  vpc_id                     = "vpc-xxxxx"
  broker_subnets             = ["subnet-xxxxxx"]
  cluster_name               = "test"
  kafka_version              = "3.7.x"
  kraft_enabled              = true
  enable_storage_autoscaling = false
  # https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html
  broker_configuration = <<PROPERTIES
group.initial.rebalance.delay.ms = 0
log.retention.hours = 72
num.io.threads = 4
num.network.threads = 2
default.replication.factor = 2
offsets.topic.replication.factor = 2
num.recovery.threads.per.data.dir = 4
delete.topic.enable = true
num.partitions = 2
min.insync.replicas = 1
auto.create.topics.enable = true
allow.everyone.if.no.acl.found = true
PROPERTIES
  number_of_brokers    = 2
  broker_instance_type = "kafka.m7g.xlarge"
  broker_volume_size   = 20
  client_authentication = {
    sasl = {
      scram = true
      iam   = true
    }
  }
  open_monitoring_enabled = true
  client_cidr_blocks      = []
  monitoring_cidr_blocks  = []
}