##################
#K8S Variables
##################

variable "key_name" {
  type    = string
  default = ""
}

variable "ports" {
  type        = list(number)
  description = "List of ports"
  default     = [22, 80, 443, 8443]
}

variable "ansible_user" {
  type    = string
  default = "ubuntu"
}

variable "instance_type" {
  type = map

  default = {
    master = "t2.medium"
    worker = "t2.micro"
  }
}
