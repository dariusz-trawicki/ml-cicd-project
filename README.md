## End to End Machine Learning Project: CI/CD Pipeline with GitHub Actions and Terraform for AWS (OIDC + Terraform + Docker)


This project shows how to deploy a `Dockerized` application to an `EC2` instance using `GitHub Actions` and `Terraform` with `OIDC` authentication.

It includes:
- `Terraform` code to set up `AWS` resources (`EC2`, `ECR`, `IAM roles`).
- `GitHub Actions` workflow to build and push `Docker` images to `ECR`, and deploy to `EC2` instance configured to run `Docker` and pull images from `ECR`.

#### 1. Create S3 bucket for state backend 

In `terraform/s3-backend/main.tf` set unique bucket name.

```bash
cd terraform/s3-backend
terraform init
terraform apply
```

#### 2. Create an IAM Role for GitHub OIDC

This step creates an IAM role that allows GitHub Actions to assume the role using OIDC. The role ARN will be outputted after the apply.

```bash
cd ../infra
terraform init
terraform apply
# Example output:
# ecr_repository_url = "ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com/myapp"
# github_oidc_role_arn = "arn:aws:iam::ACCOUNT_ID:role/github-ci-cd-repo"
# staging_instance_public_ip = "18.153.68.11"
# staging_url = "http://18.153.68.11"
```

Copy the `github_oidc_role_arn` value.

####  3. Configure `GitHub Actions`: `secret` and `workflow` 

Create Github secret:
  - **Name**: `AWS_OIDC_ROLE_ARN` 
  - **Value**: `<github_oidc_role_arn_value>`
  - **Name**: `AWS_REGION`
  - **Value**(example): `eu-central-1`

The workflow will:
  - build and push a `Docker` image to `ECR`,
  - run `terraform apply` (idempotent updates),
  - refresh the container on the `EC2` instance via `SSM`.

#### 4.Push to GitHub

When pushing to branch main or develop, the workflow will:
  - **Build & push** `ml-app:latest` to `ECR`.
  - Run `terraform apply` to ensure AWS resources are up to date.
  - Restart the container on the `EC2` instance (via `SSM`).

#### 5. Verify Results

```bash
curl http://18.153.68.11
# Output:
# <h1>Welcome to the home page</h1>
```

Open in browser: http://18.153.68.11/predictdata (fill the form, send and get the result).

#### 6. Cleanup

To destroy all resources created by Terraform, run:

```bash
cd ../infra
terraform destroy
cd ../s3
terraform destroy
```


