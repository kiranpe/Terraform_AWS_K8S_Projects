terraform {
  backend "s3" {
    profile        = "DevOps"
    region         = "us-east-2"
    bucket         = "s3-terraform-remote-state-store"
    key            = "aws/us-east-2/k8s/terraform.tfstate"
    dynamodb_table = "s3-state-lock"
  }
}
