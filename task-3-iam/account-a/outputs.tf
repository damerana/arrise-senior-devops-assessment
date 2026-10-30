output "roleA_arn" {
  value = aws_iam_role.roleA.arn
}
output "roleB_arn" {
  value = aws_iam_role.roleB.arn
}
output "group1_users" {
  value = ["engine", "ci"]
}
output "group2_users" {
  value = [for u in aws_iam_user.group2_users : u.name]
}

output "group1_access_key_ids" {
  description = "Access key IDs for the assessment's CLI-only users."
  value = {
    engine = aws_iam_access_key.engine.id
    ci     = aws_iam_access_key.ci.id
  }
}

output "group2_encrypted_console_passwords" {
  description = "PGP-encrypted initial console passwords; decrypt locally with the matching private key."
  value = {
    for name, profile in aws_iam_user_login_profile.group2_console : name => profile.encrypted_password
  }
  sensitive = true
}
