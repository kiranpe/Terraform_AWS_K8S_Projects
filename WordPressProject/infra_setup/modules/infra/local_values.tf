#Local TAGS and Values Configuration

locals {
  sec_grp_id = aws_default_security_group.default.id

  common_tags = {
    CreatedBy   = "Kiran Peddineni"
    Environment = "Non-Prod"
    Maintainer  = "Kiran Peddineni"
  }

  security_group_tags = {
    Name = "k8s-sec-group"
  }

  vpc_tags = {
    Name = "k8s-vpc"
  }

  public_subnet_tags = {
    Type = "Public"
  }

  private_subnet_tags = {
    Type = "Private"
  }

  ig_tags = {
    Name = "MyIG"
  }

  eip_tags = {
    Name = "MyEIP"
  }

  nat_tags = {
    Name = "NatGW"
  }

  route_table = {
    public  = "public-route-table"
    private = "private-route-table"
  }
}
