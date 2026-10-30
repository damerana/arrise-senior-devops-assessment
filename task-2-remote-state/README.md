# Task 2 – Remote state and locking

A local `terraform.tfstate` file is stored on one workstation. Two engineers can each plan against stale state and apply concurrently, causing conflicting writes, lost updates, duplicate resources, or drift. Local state is also not centrally shared or versioned.

S3 stores a shared state object. Enable versioning and encryption to support recovery and protect state at rest. DynamoDB locking coordinates Terraform runs using the same state key: one run acquires the lock, and a concurrent run must wait or fail instead of writing at the same time.

The S3 backend block is configured in `task-1-ec2/backend.tf`, so the EC2 module's root state is stored remotely. The bootstrap resources below create the S3 bucket and DynamoDB lock table before the first `terraform init` of Task 1.

## Bootstrap sequence
1. Copy `bootstrap-state/terraform.tfvars.example` to `terraform.tfvars`; set a globally unique bucket name.
2. In `bootstrap-state/`, run `terraform init`, `terraform plan`, `terraform apply` using local state.
3. Edit `task-1-ec2/backend.tf` with the actual bucket name.
4. In `task-1-ec2/`, run `terraform init -migrate-state`. Review the migration prompt and keep a backup of local state.

The DynamoDB table uses a string partition key named `LockID`, as required by the requested backend locking setup.
