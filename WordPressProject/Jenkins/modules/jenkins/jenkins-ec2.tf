#Jenckins EC2 Resource Configuration

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type
  key_name      = aws_key_pair.key_file.key_name

  subnet_id = data.aws_subnet.filtered_subnet.id

  connection {
    user        = var.user_name
    private_key = tls_private_key.private_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update"]
  }

  provisioner "local-exec" {
    command = <<EOT
       sleep 10;
        > ${var.jenkins_inventory_file};
          echo [jenkins] | tee -a ${var.jenkins_inventory_file};
          echo "${self.public_ip} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a ${var.jenkins_inventory_file};
          ansible-playbook -u ${var.user_name} --private-key ${local_file.key.filename} -i ${var.jenkins_inventory_file} ${var.jenkins_config_file}
     EOT
  }

  tags = local.jenkins_tags

  depends_on = [aws_key_pair.key_file]
}
