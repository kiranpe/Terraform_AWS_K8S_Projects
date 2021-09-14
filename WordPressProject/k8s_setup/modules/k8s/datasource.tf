#AMI DataSource Configuration

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#Other DataSource Configuration

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Type"
    values = [var.subnets_type]
  }
}

data "aws_subnet" "filtered_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_select]
  }
}
