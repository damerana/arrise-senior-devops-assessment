resource "aws_instance" "protected" {
  for_each      = local.protected_instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
    iops = contains(["io1", "io2"], each.value.root_volume_type) ? each.value.root_volume_iops : null
    encrypted = true
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(var.common_tags, { Name = each.key })
}
resource "aws_instance" "regular" {
  for_each      = local.regular_instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  root_block_device {
    volume_type = each.value.root_volume_type
    volume_size = each.value.root_volume_size
    iops = contains(["io1", "io2"], each.value.root_volume_type) ? each.value.root_volume_iops : null
    encrypted = true
  }
  tags = merge(var.common_tags, { Name = each.key })
}
