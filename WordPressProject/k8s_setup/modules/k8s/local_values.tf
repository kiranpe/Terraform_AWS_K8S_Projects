#Local TAGS and Values Configuration

locals {
  master_public_ip = aws_instance.main.public_ip

  common_tags = {
    CreatedBy   = "Kiran Peddineni"
    Maintainer  = "Kiran Peddineni"
    Environment = "Non-Prod"
  }
}
