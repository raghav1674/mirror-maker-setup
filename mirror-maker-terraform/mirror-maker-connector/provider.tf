provider "kafka-connect" {
  url = "http://${var.kafka_connect_lb_dns}:8083"
}

provider "aws" {
  region = var.source_region
}

provider "aws" {
  region = var.target_region
  alias  = "target"
}