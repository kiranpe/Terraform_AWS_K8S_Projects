terraform {
    backend "s3" {
        bucket = "terraform-remote-state-s3-store"
        key    = "aws/us-east-2/k8s/terraform.tfstate"
        dynamodb_table = "s3-state-lock"
        region = "us-east-2"
    }
}