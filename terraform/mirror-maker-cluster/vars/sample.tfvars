kafka_connect_properties = {
  "security.protocol" : "SASL_SSL",
  "sasl.mechanism" : "SCRAM-SHA-512",
  "sasl.jaas.config" : "org.apache.kafka.common.security.scram.ScramLoginModule required  username=\"username\" password=\"password\"; ",
  "producer.security.protocol" : "SASL_SSL",
  "producer.sasl.mechanism" : "SCRAM-SHA-512"
  "producer.sasl.jaas.config" : "org.apache.kafka.common.security.scram.ScramLoginModule required  username=\"username\" password=\"password\"; ",
}

bootstrap_servers = "broker-dest"

cluster_suffix = "test"

vpc_id = "vpc-xxxxxxxxx"

ssh_key_name = "mm2"

connect_instances = [
  {
    name          = "connect-1"
    instance_type = "m6g.large"
    subnet_id     = "subnet-xxxxxxxxxx"
  },
  {
    name          = "connect-2"
    instance_type = "m6g.large"
    subnet_id     = "subnet-xxxxxxxxx"
  },
  {
    name          = "connect-3"
    instance_type = "m6g.large"
    subnet_id     = "subnet-xxxxxxxxxx"
  }
]

dd_api_key                    = "xxxx"
dd_site                       = "us5.datadoghq.com"
additional_security_group_ids = ["sg-xxxxxxxxxx"]

# monitoring_instance = {
#     name          = "monitoring"
#     instance_type = "t4g.large"
#     subnet_id     = "subnet-xxxxxxxxx"
#     source_exporter_args = {
#       "kafka.server" : "broker-source",
#       "sasl.enabled" : "",
#       "sasl.username" : "username",
#       "sasl.password" : "password",
#       "sasl.mechanism": "scram-sha512",
#       "tls.enabled" : ""
#     }
#     target_exporter_args = {
#       "kafka.server" : "broker-dest"
#       "sasl.enabled" : "",
#       "sasl.username" : "username",
#       "sasl.password" : "password",
#       "sasl.mechanism": "scram-sha512",
#       "tls.enabled" : ""
#     }
# }

default_tags = {
  "Owner"       = "user"
  "Environment" = "test"
}