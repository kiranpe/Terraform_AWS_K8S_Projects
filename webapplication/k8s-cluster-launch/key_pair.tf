###################
#K8S Key Pair
###################

locals {
  key_tags = {
    CreatedBy = "Kiran Peddineni"
    Tool      = "Terraform"
    Approver  = "Kiran Peddineni"
  }
}

resource "tls_private_key" "access_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "k8s_key" {
  key_name   = "k8skey"
  public_key = tls_private_key.access_key.public_key_openssh

  depends_on = [
    tls_private_key.access_key
  ]

  tags = local.key_tags
}

resource "local_file" "key_file" {
  content         = tls_private_key.access_key.private_key_pem
  filename        = "k8skey.pem"
  file_permission = "0600"

  depends_on = [
    tls_private_key.access_key,
    aws_key_pair.k8s_key
  ]
}
