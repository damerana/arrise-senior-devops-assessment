# Arrise Senior DevOps Engineer Assessment

Contains implementations for Tasks 1–5. Keep the assessment account IDs exactly as specified: Account A `000000000000` and Account B `111111111111`. Replace only resource-specific placeholders (AMI IDs, key-pair names, bucket names, repository/service names, and the PGP public key) if performing a real plan/apply. This is a source-code submission, not proof of a successful AWS deployment.

## Layout
- task-1-ec2: five EC2 instances driven by one map input and reusable module
- task-2-remote-state: S3/DynamoDB backend explanation and bootstrap resources (the backend block is in task-1-ec2/backend.tf)
- task-3-iam/account-a: groups, users, roleA, roleB
- task-3-iam/account-b: roleC and single-bucket S3 permissions
- task-4-ci-policy: least-privilege CI policy JSON
- task-5-bug-fix: corrected trust and S3 policy

Run `terraform fmt -recursive`. Bootstrap the S3 bucket and DynamoDB table from `task-2-remote-state/bootstrap-state/` first. Then run `terraform init` and `terraform validate` in `task-1-ec2/`, `task-3-iam/account-a/`, `task-3-iam/account-b/`, and `task-2-remote-state/bootstrap-state/`. The Task 1 backend bucket name must match the bucket created by the bootstrap stack. AWS credentials and valid account resources are needed for a real plan/apply. Review plans carefully; AWS resources may incur charges. Never commit access keys, private keys, passwords, or Terraform state.

Task 1 uses two `aws_instance` resource blocks, both driven by filtered views of the same input map. Terraform lifecycle meta-arguments must be literal constants, so `prevent_destroy = each.value.prevent_destroy` is not supported. The protected block has literal `prevent_destroy = true`; the regular block omits it. The example protects `app-01`.

Task 2: create the S3 bucket and DynamoDB table from `bootstrap-state/` using local state first. Then edit `backend.tf` with the real bucket name and run `terraform init -migrate-state`. Keep a backup of local state. DynamoDB locking is included because the assessment explicitly asks for it.

Task 3 interpretation: group2 is attached to `AdministratorAccess` to demonstrate full AWS permissions. Console credentials are deliberately not generated/stored in Terraform; create them securely outside Terraform or use IAM Identity Center. group1 users have no console login profile. RoleA allows all actions except `iam:*`.

Production recommendation: use IAM Identity Center/federation for human access and OIDC/workload roles for CI instead of long-lived IAM user keys. For the assessment, group1 (`engine` and `ci`) receives programmatic access keys, and group2 users receive PGP-encrypted initial console passwords. These credentials are created only to demonstrate the requested access modes; the access-key secrets are stored in Terraform state. Protect state and never commit it. In production, replace the long-lived IAM-user keys with federated/workload credentials.

Task 4: ECR authorization token requires `Resource: "*"`. ECS task-definition registration is set to `"*"` for broad API compatibility; validate the final policy in IAM Access Analyzer and against the actual pipeline.


## GitHub Actions validation (no local Terraform installation)

A GitHub Actions workflow is included at `.github/workflows/terraform-validation.yml`.
Upload/push this project to your GitHub repository, open the **Actions** tab, and select
**Terraform validation**. It runs `terraform fmt -check`, initializes each Terraform root
with `-backend=false`, runs `terraform validate`, and parses the Task 4 IAM JSON policy.
This does not require AWS credentials and does not create AWS resources. It checks Terraform
configuration validity, not the correctness of a live AWS deployment or remote backend access.
