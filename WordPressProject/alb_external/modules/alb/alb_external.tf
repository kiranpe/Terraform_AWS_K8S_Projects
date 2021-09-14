
###################
#AppLoadBalancer
###################

resource "aws_lb" "alb" {
  count = var.create_lb ? 1 : 0

  name               = var.alb_name
  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  subnets            = data.aws_subnet_ids.selected.ids

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }

  tags = local.common_tags
}

#######################
#TargetGroup
#######################

resource "aws_lb_target_group" "alb_target_group" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = var.tg_name
  port        = var.instance_port
  protocol    = lookup(var.target_groups[count.index], "backend_protocol", null)
  target_type = lookup(var.target_groups[count.index], "target_type", null)

  vpc_id = data.aws_vpc.vpc.id

  stickiness {
    type            = var.stickiness_type
    cookie_duration = var.session_cookie_duration
    enabled         = var.target_group_sticky
  }

  dynamic "health_check" {
    for_each = var.health_check
    content {
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = var.instance_port
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
    }
  }

  depends_on = [aws_lb.alb]

  tags = local.common_tags
}

################
#ALBListener
################

resource "aws_lb_listener" "alb_listener" {
  count = var.create_lb ? length(var.http_listeners) : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.instance_port
  protocol          = lookup(var.http_listeners[count.index], "protocol", "HTTPS")

  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group[0].arn
    type             = var.listener_action_type
  }
}

##################################################
#ALBListenerRule
##################################################

resource "aws_lb_listener_rule" "http_listener_rule" {
  count = var.create_lb && length(var.http_listener_rules) > 0 ? length(var.http_listener_rules) : 0

  listener_arn = aws_lb_listener.alb_listener[0].arn
  priority     = lookup(var.http_listener_rules[count.index], "priority", null)

  action {
    type             = var.listener_rule_action_type
    target_group_arn = aws_lb_target_group.alb_target_group[0].id
  }

  condition {
    path_pattern {
      values = ["/wp-login.php"]
    }
  }

  depends_on = [aws_lb_target_group.alb_target_group]
}

################################
#Target Group Attachement
################################

resource "aws_lb_target_group_attachment" "instance" {
  count            = length(data.aws_instances.k8s.ids)
  target_group_arn = aws_lb_target_group.alb_target_group[0].arn
  target_id        = data.aws_instances.k8s.ids[count.index]
  port             = var.instance_port
}
