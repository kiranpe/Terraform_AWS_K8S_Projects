#Variables Configuration

variable "tls_key_algo" {
  description = "TLS Private key Alogirithm type"
  type        = string
  default     = "RSA"
}

variable "key" {
  description = "SSH key name"
  type        = string
  default     = "jenkins"
}

variable "pem_file" {
  description = "Local .pem file Name"
  type        = string
  default     = "jenkins.pem"
}

variable "file_permission" {
  description = "Local .pem file permission"
  type        = string
  default     = "0600"
}

variable "ec2_type" {
  description = "EC2 disk type"
  type        = string
  default     = "t2.medium"
}

variable "vpc_name" {
  description = "VPC name to Launch EC2"
  type        = string
  default     = "k8s-vpc"
}

variable "subnet_select" {
  description = "Subnet yto Launch EC2"
  type        = string
  default     = "public-subnet-0"
}

variable "user_name" {
  description = "Username to connect to EC2"
  type        = string
  default     = "ubuntu"
}

variable "jenkins_config_file" {
  description = "Jenkins Configuration file location"
  type        = string
  default     = "ymlfile/configure-jenkins.yml"
}

variable "jenkins_inventory_file" {
  description = "Jenkins inventory file location"
  type        = string
  default     = "ymlfile/jenkins"
}
