locals {
    create_monitoring_instance = var.monitoring_instance != null
}

data "cloudinit_config" "monitoring" {
  count         = local.create_monitoring_instance ? 1 : 0
  gzip          = true
  base64_encode = true
  part {
    filename     = "main.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/user-data/monitoring.sh", {
      source_exporter_args = var.monitoring_instance.source_exporter_args
      target_exporter_args = var.monitoring_instance.target_exporter_args
      dd_api_key = var.dd_api_key
      dd_site    = var.dd_site
    })
  }
}

resource "aws_instance" "monitoring" {
  count                  = local.create_monitoring_instance ? 1 : 0
  ami                    = data.aws_ami.amzn_2023_arm64.id
  instance_type          = var.monitoring_instance.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = var.monitoring_instance.subnet_id
  vpc_security_group_ids = concat([aws_security_group.this.id], var.additional_security_group_ids)
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 50
  }
  user_data_base64            = data.cloudinit_config.monitoring[0].rendered
  user_data_replace_on_change = true
  tags = {
    Name =  var.monitoring_instance.name
  }
}