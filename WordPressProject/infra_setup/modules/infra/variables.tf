variable "enable_dns_host_support" {
  description = "Enable dns hostname and support"
  type        = bool
  default     = true
}

variable "create_eip" {
  description = "Create eip for VPC"
  type        = bool
  default     = true
}

variable "public_ip_for_public_instance" {
  description = "Create Public Ip for Public Subnet Instance"
  type        = bool
  default     = true
}

variable "public_ip_for_private_instance" {
  description = "Create Public Ip for Public Subnet Instance"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Public Subnet CIDR Block"
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Private Subnet CIDR Block"
  type        = list(any)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of Availability Zones to Launch subnets"
  type        = list(any)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "ports" {
  description = "List of Security Group Ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "cidr" {
  description = "CIDR block to allow traffic in Sec Group"
  type        = string
  default     = "0.0.0.0/0"
}

variable "protocol_type" {
  description = "Protocol used in Sec Group"
  type        = string
  default     = "tcp"
}
