# terraform/primitives/oidc-trust/main.tf
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "us-east-1" }

variable "github_org"  { type = string }
variable "github_repo" { type = string }

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "grc_gate" {
  name = "cgep-grc-gate"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = { "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com" }
        StringLike   = {
          "token.actions.githubusercontent.com:sub" = [
            "repo:${var.github_org}/${var.github_repo}:*",     # repos created before Jul 15 2026
            "repo:${var.github_org}@*/${var.github_repo}@*:*", # repos created after: GitHub adds owner + repo IDs
          ]
        }
      }
    }]
  })
}
#Lab 4.4: Changed IAM policy from read only to limited writing
resource aws iam put-role-policy \
  --role-name cgep-grc-gate \
  --policy-name vault-write \
  --policy-document "$(cat <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Action":["s3:PutObject","s3:GetObject","s3:GetBucketLocation"],
    "Resource":["arn:aws:s3:::${VAULT}","arn:aws:s3:::${VAULT}/*"]
  }]
}
EOF)"

output "role_arn" { value = aws_iam_role.grc_gate.arn }