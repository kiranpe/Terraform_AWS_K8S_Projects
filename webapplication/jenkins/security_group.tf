##################
#Security Group
##################

locals {
  common_tags = {
    Name      = "JenkinsGroup"
    CreatedBy = "Kiran Peddineni"
  }
}

resource "aws_security_group" "jenkins" {

  dynamic "ingress" {
    for_each = var.ports

    content {
      description = "jenkins sec grp"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "jenkins sec grp"
    from_port   = 0
    to_port     = 65353
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
