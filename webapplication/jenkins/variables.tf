############
#Variables
############

variable "user_name" {
  type    = string
  default = "ubuntu"
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "subnet_ids" {
  type    = string
  default = "subnet-85ea84c9"
}