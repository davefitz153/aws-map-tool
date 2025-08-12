#!/bin/bash
set -e

# Name of your SSM parameter holding the IAM role ARN
SSM_PARAM_NAME="/mapapp/lambda/role_arn"

echo "Fetching Lambda role ARN from SSM Parameter Store..."
LAMBDA_ROLE_ARN=$(aws ssm get-parameter --name "$SSM_PARAM_NAME" --query Parameter.Value --output text)

echo "Lambda Role ARN: $LAMBDA_ROLE_ARN"

echo "Building SAM application..."
sam build

echo "Deploying SAM application..."
sam deploy \
  --stack-name get-datasets \
  --parameter-overrides LambdaRoleArn="$LAMBDA_ROLE_ARN" \
  --capabilities CAPABILITY_NAMED_IAM \
  --guided
