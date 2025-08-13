variable "aws_region" {
  description = "AWS region to create the backend resources in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the Terraform state S3 bucket (random suffix will be added)"
  type        = string
  default     = "my-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks"
}
