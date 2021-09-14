#DataSource Configuration

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

data "aws_security_groups" "secgrp" {
  tags = {
    Name        = var.sec_grp
    Environment = var.env
  }
}

data "aws_instances" "k8s" {
  filter {
    name   = "tag:Environment"
    values = [var.env]
  }
}
