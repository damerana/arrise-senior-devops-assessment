terraform {
  backend "s3" {
    bucket         = "REPLACE_WITH_UNIQUE_STATE_BUCKET"
    key            = "arrise-assessment/ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "arrise-terraform-locks"
    encrypt        = true
  }
}
