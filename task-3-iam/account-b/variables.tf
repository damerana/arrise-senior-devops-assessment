variable "aws_region" {
  type = string
  default = "ap-south-1"
}
variable "account_a_id" {
  type = string
  default = "000000000000"
}
variable "account_b_id" {
  type = string
  default = "111111111111"
}
variable "role_b_name" {
  type = string
  default = "roleB"
}
variable "bucket_name" {
  type = string
  default = "REPLACE_WITH_TARGET_BUCKET"
}
