###############
#Tags
###############
locals {
  lb_dns_name = aws_lb.alb.*.dns_name

  common_tags = {
    CreatedBy   = var.CreatedBy
    Environment = var.environment
    Maintainer  = var.Maintainer
  }
}
