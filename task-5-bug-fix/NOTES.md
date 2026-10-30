# Task 5 – bug fixes

1. **Trust-policy principal type/ARN is wrong.** The original principal is `arn:aws:iam::000000000000:user/roleB`, which identifies an IAM user named `roleB`. The intended principal is an IAM role, so the corrected ARN is `arn:aws:iam::000000000000:role/roleB`. Without that role principal, the intended Account A role cannot assume roleC.
2. **The S3 permissions policy is over-broad.** `s3:*` with `Resource = "*"` grants S3 actions against resources beyond the one intended bucket. The corrected policy keeps the requested full S3 action set but scopes it to the bucket ARN (`arn:aws:s3:::bucket-name`) and its object ARN pattern (`arn:aws:s3:::bucket-name/*`). Bucket-level and object-level S3 actions use different ARN forms.

`fixed-example.tf` contains the complete corrected role and inline policy resources.
