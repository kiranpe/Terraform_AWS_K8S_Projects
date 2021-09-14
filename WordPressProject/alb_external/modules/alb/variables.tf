#############
#Tags
#############

variable "CreatedBy" {
  type    = string
  default = "Kiran Peddineni"
}

variable "Maintainer" {
  type    = string
  default = "Kiran Peddineni"
}

variable "environment" {
  type    = string
  default = "non-prod"
}

######################
#ALB
######################

variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

variable "alb_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = "public-wp-alb"
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "10m"
}

###############
#Target Group
###############

variable "tg_name" {
  description = "Name of the Target Group"
  type        = string
  default     = "MyWPRule"
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Required key/values: backend_protocol, backend_port, target_type"
  type        = any
  default = [
    {
      backend_protocol = "HTTP"
      target_type      = "instance"
    }
  ]
}

variable "stickiness_type" {
  description = "Session stickiness type"
  type        = string
  default     = "lb_cookie"
}

variable "session_cookie_duration" {
  description = "session stickiness duration"
  type        = number
  default     = 600
}

variable "target_group_sticky" {
  description = "enable session stickyness"
  type        = bool
  default     = false
}

variable "health_check" {
  description = "A list of maps containing key/value pairs that define health check. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default = [
    {
      interval            = 30
      path                = "/wp-login.php"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
      protocol            = "HTTP"
    }
  ]
}

#############
#Listeners
#############

variable "http_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default = [
    {
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

variable "listener_action_type" {
  description = "Listener Action type"
  type        = string
  default     = "forward"
}

variable "https_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to https_listeners[count.index])"
  type        = any
  default     = []
}

variable "listener_ssl_policy_default" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

################
#Listener Rules
################

variable "http_listener_rules" {
  description = "A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https_listener_index (default to https_listeners[count.index])"
  type        = any
  default = [
    {
      http_listener_index = 0
      priority            = 1
    },
  ]
}

variable "listener_rule_action_type" {
  description = "Listener Rule Action Type"
  type        = string
  default     = "forward"
}

#################
#DataSource Tags
#################

variable "vpc_name" {
  description = "VPC Name to choose"
  type        = string
  default     = "k8s-vpc"
}

variable "subnets_type" {
  description = "Filter Public subnets"
  type        = string
  default     = "Public"
}

variable "subnet_select" {
  description = "Filter and Choose Subnet to Launch EC2"
  type        = string
  default     = "public-subnet-0"
}

variable "sec_grp" {
  description = "Select vpc security group"
  type        = string
  default     = "k8s-sec-group"
}

variable "env" {
  description = "Filter instances on env base"
  type        = string
  default     = "Non-Prod"
}

#######################
#EC2 Instance
#######################

variable "instance_port" {
  description = "The size of instance to launch"
  type        = number
  default     = 30019
}
