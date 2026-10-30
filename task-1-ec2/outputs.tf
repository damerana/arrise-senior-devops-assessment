output "instance_ids_by_name" {
  value = merge(module.ec2_instances.instance_ids_protected, module.ec2_instances.instance_ids_regular)
}
output "private_ips_by_name" {
  value = merge(module.ec2_instances.private_ips_protected, module.ec2_instances.private_ips_regular)
}
