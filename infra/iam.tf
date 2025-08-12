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
