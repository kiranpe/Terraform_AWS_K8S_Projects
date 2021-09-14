#####################
#Backend Config
#####################

terraform {
  backend "s3" {
    region               = "us-east-2"
    bucket               = "s3-terraform-remote-state-store"
    key                  = "aws/us-east-2/terraform.tfstate"
    dynamodb_table       = "s3-state-lock"
    workspace_key_prefix = "K8S"
  }
}
