resource "aws_dynamodb_table" "datasets" {
  name         = "Datasets"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  global_secondary_index {
    name            = "CategoryIndex"
    hash_key        = "category"
    projection_type = "ALL" # Projects all attributes into the index
  }

  tags = {
    Environment = var.environment
    Project     = "Map Tool"
    TestDeploy = "true"
  }
}
