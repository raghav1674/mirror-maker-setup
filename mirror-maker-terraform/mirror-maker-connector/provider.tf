provider "kafka-connect" {
  url = var.kafka_connect_url
}

provider "aws" {
  region = var.region
}