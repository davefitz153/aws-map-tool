data "aws_iam_policy_document" "lambda_dynamo_policy" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = [
      aws_dynamodb_table.datasets.arn,
      "${aws_dynamodb_table.datasets.arn}/index/*" # Include GSIs if used
    ]
  }
}

resource "aws_iam_role_policy" "lambda_dynamo_access" {
  name   = "LambdaDynamoDBAccess"
  role   = aws_iam_role.lambda_exec_role.id
  policy = data.aws_iam_policy_document.lambda_dynamo_policy.json
}


resource "aws_iam_role" "lambda_exec_role" {
  name               = "my-lambda-exec-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_ssm_parameter" "lambda_role_arn" {
  name  = "/mapapp/lambda/role_arn"
  type  = "String"
  value = aws_iam_role.lambda_exec_role.arn
}

resource "aws_iam_user" "github_actions_user" {
  name = "github-actions-deploy"
}

resource "aws_iam_user_policy" "deploy_policy" {
  name = "github-actions-deploy-policy"
  user = aws_iam_user.github_actions_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # S3
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket",

          # Lambda
          "lambda:*",

          # API Gateway (both REST and HTTP APIs)
          "apigateway:*",

          # DynamoDB
          "dynamodb:*",

          # CloudFormation for SAM
          "cloudformation:*",

          # IAM for Lambda execution role pass
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:ListUserPolicies",
          "iam:ListAccessKeys",
          "iam:PassRole",

          # SSM Parameter Store (read)
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DescribeParameters",
          "ssm:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

# Access key (store in GitHub Secrets)
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions_user.name
}

output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions_key.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}