variable "instances" {
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
variable "common_tags" {
  type    = map(string)
  default = {}
}
locals {
  protected_instances = {
    for name, cfg in var.instances : name => cfg if cfg.prevent_destroy
  }
  regular_instances = {
    for name, cfg in var.instances : name => cfg if !cfg.prevent_destroy
  }
}
