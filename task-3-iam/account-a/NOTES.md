# Account A notes

## Would I give engine and ci IAM user keys in production?
No. For humans, use IAM Identity Center/federated SSO, MFA, and short-lived role sessions. For CI/CD, use OIDC federation or a workload execution role to obtain temporary credentials. This avoids static secrets, reduces key leakage risk, and removes manual key rotation. For this assessment, `engine` and `ci` receive IAM access keys so they can use the CLI/programmatic interface. Terraform stores the secret access keys in state, so state must be encrypted, access-controlled, and never committed. In production, I would not issue long-lived IAM-user keys: use IAM Identity Center/federated SSO for humans and OIDC/workload roles for CI/CD. This provides short-lived credentials and avoids static-secret rotation.

## Trusting Account A root vs roleB
Trusting `arn:aws:iam::000000000000:root` delegates trust to the account. Principals in Account A can assume the role if Account A grants them `sts:AssumeRole`; it does not automatically grant every principal access, but it is a wider trust boundary. Trusting only `arn:aws:iam::000000000000:role/roleB` is narrower and follows least privilege. Account B roleC therefore trusts roleB specifically.

## Console and CLI
CLI access uses access keys or temporary credentials. Console access additionally requires a sign-in profile or federation. This Terraform intentionally does not generate passwords or access keys in state. The group2 users receive PGP-encrypted initial console passwords through `aws_iam_user_login_profile`; supply a valid base64-encoded PGP public key using `console_user_pgp_key`, then decrypt the output with the matching private key. They can use the console and, with their full permissions, create CLI access keys if needed. group2 is attached to `AdministratorAccess` as the assessment interpretation of full permissions; this is highly privileged and should be reviewed before production.
