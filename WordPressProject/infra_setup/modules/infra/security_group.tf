#K8s Security Group Configuration

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.ports

    content {
      description = "k8s security group"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol_type
      cidr_blocks = [var.cidr]
    }
  }

  ingress {
    description = "k8s security group"
    from_port   = 0
    to_port     = 65535
    protocol    = var.protocol_type
    cidr_blocks = [var.cidr]
  }

  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr]
  }

  depends_on = [aws_vpc.vpc]

  tags = merge(local.common_tags, local.security_group_tags)
}
