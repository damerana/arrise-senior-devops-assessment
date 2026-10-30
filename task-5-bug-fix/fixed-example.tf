variable "account_a_id" {
  type    = string
  default = "000000000000"
}

variable "bucket_name" {
  type    = string
  default = "REPLACE_WITH_TARGET_BUCKET"
}

data "aws_iam_policy_document" "roleC_trust_fixed" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:role/roleB"]
    }
  }
}

resource "aws_iam_role" "roleC" {
  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust_fixed.json
}

data "aws_iam_policy_document" "roleC_s3_fixed" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "roleC_s3" {
  name   = "roleC-s3-access"
  role   = aws_iam_role.roleC.id
  policy = data.aws_iam_policy_document.roleC_s3_fixed.json
}
