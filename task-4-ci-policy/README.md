# Task 4 – CI least privilege

Replace sample account, region, ECR repository, ECS cluster/service, task role ARNs, and artifacts bucket. Attach the policy to the CI identity or preferably a federated CI role.

Allows ECR authentication and push to one repository; task-definition registration/description; update/describe of one ECS service; PassRole only for the named task and execution roles when passed to ECS tasks; and ListBucket/GetObject only for one build-artifacts bucket.

It omits ECR deletion, S3 writes/deletes, broad IAM administration, arbitrary PassRole, and changes to unrelated ECS services. ECR authorization token requires `Resource: "*"`. ECS task-definition registration is set to `"*"` for common deployment compatibility; validate with IAM Access Analyzer and the real pipeline.
