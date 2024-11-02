module "msk" {
  source         = "../modules/msk"
  vpc_id         = "vpc-02f921ec15fbafd93"
  broker_subnets = ["subnet-060e51dc9c2fbec3f"]
  cluster_name   = "test"
  kafka_version  = "3.7.1"
  kraft_enabled  = true
  # https://docs.aws.amazon.com/msk/latest/developerguide/bestpractices.html
  broker_configuration = <<PROPERTIES
group.initial.rebalance.delay.ms = 0
log.retention.hours = 72
num.io.threads = 8
num.network.threads = 4
default.replication.factor = 3 
offsets.topic.replication.factor = 3 
num.recovery.threads.per.data.dir = 8 
delete.topic.enable = true
num.partitions = 5
min.insync.replicas = 1
auto.create.topics.enable = false
allow.everyone.if.no.acl.found = false
PROPERTIES
  number_of_brokers    = 1
  broker_instance_type = "kafka.m5.large"
  broker_volume_size   = 100
  client_authentication = {
    sasl = {
      scram = true
      iam   = true
    }
    tls = true
  }
  open_monitoring_enabled = true
  client_cidr_blocks      = []
  monitoring_cidr_blocks  = []
}