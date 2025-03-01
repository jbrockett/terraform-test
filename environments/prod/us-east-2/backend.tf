terraform {
  backend "s3" {
    bucket         = "terraform-state-ebc186e7-6441-4f79-a59d-22b22ba97d3e"
    key            = "environments/prod/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
