#SSH Key Configuration

resource "tls_private_key" "private_key" {
  algorithm = var.tls_key_algo
}

resource "aws_key_pair" "key_file" {
  key_name   = var.key
  public_key = tls_private_key.private_key.public_key_openssh


  depends_on = [
    tls_private_key.private_key
  ]
}

resource "local_file" "key" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = var.pem_file
  file_permission = var.file_permission

  depends_on = [
    tls_private_key.private_key,
    aws_key_pair.key_file
  ]
}
