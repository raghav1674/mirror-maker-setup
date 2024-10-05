resource "aws_instance" "this" {
  for_each               = { for instance in var.connect_instances : instance.name => instance }
  ami                    = data.aws_ami.amzn_2023_arm64.id
  instance_type          = each.value.instance_type
  key_name               = var.ssh_key_name
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = concat([aws_security_group.this.id],var.additional_security_group_ids)
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 200
  }
  user_data_base64 = data.cloudinit_config.this.rendered
  user_data_replace_on_change = true
  tags = {
    Name = each.value.name
  }
}