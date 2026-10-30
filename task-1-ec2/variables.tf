variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "environment" {
  type    = string
  default = "assessment"
}
variable "owner" {
  type    = string
  default = "candidate"
}
variable "instances" {
  description = "All EC2 instances, keyed by logical name."
  type = map(object({
    ami              = string
    instance_type    = string
    key_name         = string
    root_volume_type = string
    root_volume_size = number
    root_volume_iops = optional(number)
    prevent_destroy  = optional(bool, false)
  }))
}
