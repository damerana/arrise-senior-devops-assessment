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
variable "console_users" {
  description = "Two candidate-selected users for group2."
  type = set(string)
  default = ["candidate-user-1", "candidate-user-2"]
}

variable "console_user_pgp_key" {
  description = "Base64-encoded PGP public key used to encrypt initial console passwords for group2 users."
  type        = string
  default     = "REPLACE_WITH_BASE64_ENCODED_PGP_PUBLIC_KEY"
}
