provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "youtil-tfstate-bucket"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
    Env  = "init"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "youtil-tflock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
    Env  = "init"
  }
}