#VPC Network Configuration

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = var.enable_dns_host_support
  enable_dns_support   = var.enable_dns_host_support

  tags = merge(local.vpc_tags, local.common_tags)
}

#IneternetGateway Configuration

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, local.ig_tags)
}

#EIP Configuration

resource "aws_eip" "nat_eip" {
  vpc        = var.create_eip
  depends_on = [aws_internet_gateway.ig]

  tags = merge(local.common_tags, local.eip_tags)
}

#Subnet Configuration

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnets_cidr)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.public_ip_for_public_instance

  tags = merge(local.common_tags, local.public_subnet_tags, tomap({ Name = "public-subnet-${count.index}" }))
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = var.public_ip_for_private_instance

  tags = merge(local.common_tags, local.private_subnet_tags, tomap({ Name = "private-subnet-${count.index}" }))
}

#NAT Gate Way Configuration

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = merge(local.common_tags, local.nat_tags)
}

#Route Table Configuration

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = tomap({ Name = local.route_table.private })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = tomap({ Name = local.route_table.public })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.cidr
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.cidr
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
