variable "aws_region" {
  type = string
  default = "ap-south-1"
}
variable "state_bucket_name" {
  type = string
  default = "REPLACE_WITH_GLOBALLY_UNIQUE_BUCKET"
}
variable "lock_table_name" {
  type = string
  default = "arrise-terraform-locks"
}
