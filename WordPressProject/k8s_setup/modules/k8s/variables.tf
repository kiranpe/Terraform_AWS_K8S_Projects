#EC2 Variables

variable "disk_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.medium"
}

variable "user_name" {
  description = "User Name to connect to Host"
  type        = string
  default     = "ubuntu"
}

#DataSource Variables

variable "vpc_name" {
  description = "VPC Name to Launch EC2"
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

#SSH Key Variables

variable "tls_key_alog" {
  description = "TLS Private Key Algorithm Type"
  type        = string
  default     = "RSA"
}

variable "key" {
  description = "SSH Key Name"
  type        = string
  default     = "k8skey"
}

variable "pem_file" {
  description = "Local .pem file Name"
  type        = string
  default     = "k8skey.pem"
}

variable "file_permission" {
  description = "Local .pem file permissions"
  type        = string
  default     = "0600"
}

#K8s Nodes Variables

variable "master_node_inventory_file" {
  description = "File to store Master IP"
  type        = string
  default     = "ymlfiles/masterhost"
}

variable "master_node_config_file" {
  description = "Master Configuration file"
  type        = string
  default     = "ymlfiles/configure-master-node.yml"
}

variable "worker_node_inventory_file" {
  description = "File to store Master IP"
  type        = string
  default     = "ymlfiles/workerhost"
}

variable "worker_node_config_file" {
  description = "Master Configuration file"
  type        = string
  default     = "ymlfiles/configure-worker-nodes.yml"
}

variable "wordpress_installation_file" {
  description = "WordPress Installation file location"
  type        = string
  default     = "install_wordpress/install_wordpress.yaml"
}
