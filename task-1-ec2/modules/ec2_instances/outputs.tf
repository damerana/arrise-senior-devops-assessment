output "instance_ids_protected" {
  value = { for n, v in aws_instance.protected : n => v.id }
}
output "instance_ids_regular" {
  value = { for n, v in aws_instance.regular : n => v.id }
}
output "private_ips_protected" {
  value = { for n, v in aws_instance.protected : n => v.private_ip }
}
output "private_ips_regular" {
  value = { for n, v in aws_instance.regular : n => v.private_ip }
}
