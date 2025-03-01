terraform {
  backend "s3" {
    bucket         = "terraform-state-ebc186e7-6441-4f79-a59d-22b22ba9742a"
    key            = "environments/dev/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
