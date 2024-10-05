data "aws_ami" "amzn_2023_arm64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  owners = ["137112412989"]
}


data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "main.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/user-data/main.sh", {
      bootstrap_servers = var.bootstrap_servers
      cluster_suffix    = var.cluster_suffix
      kafka_connect_properties = var.kafka_connect_properties
      dd_api_key = var.dd_api_key
      dd_site = var.dd_site
    })
  }
}
