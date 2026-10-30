data "aws_iam_policy_document" "group1_console_deny" {
  statement {
    effect = "Deny"
    actions = ["signin:ConsoleLogin"]
    resources = ["*"]
  }
}
resource "aws_iam_group" "group1" {
  name = "group1"
}
resource "aws_iam_group" "group2" {
  name = "group2"
}
resource "aws_iam_group_policy" "group1_console_deny" {
  name = "deny-console-login"
  group = aws_iam_group.group1.name
  policy = data.aws_iam_policy_document.group1_console_deny.json
}
resource "aws_iam_user" "engine" {
  name = "engine"
}
resource "aws_iam_user" "ci" {
  name = "ci"
}

# Assessment-only programmatic credentials for the CLI-only group.
# The secret access keys are stored in Terraform state; protect state accordingly.
resource "aws_iam_access_key" "engine" {
  user = aws_iam_user.engine.name
}
resource "aws_iam_access_key" "ci" {
  user = aws_iam_user.ci.name
}
resource "aws_iam_group_membership" "group1_members" {
  name = "group1-members"
  group = aws_iam_group.group1.name
  users = [aws_iam_user.engine.name, aws_iam_user.ci.name]
}
resource "aws_iam_user" "group2_users" {
  for_each = var.console_users
  name = each.value
}

# Console passwords are encrypted with the candidate's PGP public key.
resource "aws_iam_user_login_profile" "group2_console" {
  for_each                = aws_iam_user.group2_users
  user                    = each.value.name
  pgp_key                 = var.console_user_pgp_key
  password_length         = 20
  password_reset_required = true
}
resource "aws_iam_group_membership" "group2_members" {
  name = "group2-members"
  group = aws_iam_group.group2.name
  users = [for u in aws_iam_user.group2_users : u.name]
}
resource "aws_iam_group_policy_attachment" "group2_admin" {
  group = aws_iam_group.group2.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
data "aws_iam_policy_document" "roleA_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:root"]
    }
  }
}
resource "aws_iam_role" "roleA" {
  name = "roleA"
  assume_role_policy = data.aws_iam_policy_document.roleA_trust.json
}
data "aws_iam_policy_document" "roleA_policy_doc" {
  statement {
    effect = "Allow"
    not_actions = ["iam:*"]
    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "roleA_policy" {
  name = "admin-except-iam"
  role = aws_iam_role.roleA.id
  policy = data.aws_iam_policy_document.roleA_policy_doc.json
}
data "aws_iam_policy_document" "roleB_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:root"]
    }
  }
}
resource "aws_iam_role" "roleB" {
  name = "roleB"
  assume_role_policy = data.aws_iam_policy_document.roleB_trust.json
}
data "aws_iam_policy_document" "roleB_policy_doc" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.account_b_id}:role/roleC"]
  }
}
resource "aws_iam_role_policy" "roleB_policy" {
  name = "assume-roleC-only"
  role = aws_iam_role.roleB.id
  policy = data.aws_iam_policy_document.roleB_policy_doc.json
}
