data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:role/${var.role_b_name}"]
    }
  }
}
resource "aws_iam_role" "roleC" {
  name = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}
data "aws_iam_policy_document" "roleC_bucket_access" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}
resource "aws_iam_role_policy" "roleC_s3" {
  name = "roleC-single-bucket-full-access"
  role = aws_iam_role.roleC.id
  policy = data.aws_iam_policy_document.roleC_bucket_access.json
}
