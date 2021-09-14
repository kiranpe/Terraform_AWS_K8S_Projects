#K8s Master Configuration

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.disk_type
  key_name      = aws_key_pair.key_file.key_name

  subnet_id = data.aws_subnet.filtered_subnet.id

  connection {
    user        = var.user_name
    private_key = tls_private_key.private_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update && sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install ansible -y"]
  }

  provisioner "local-exec" {
    command = <<EOT
       sleep 10;
        > ${var.master_node_inventory_file};
          echo [k8smaster] | tee -a ${var.master_node_inventory_file};
          echo "${self.public_ip} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a ${var.master_node_inventory_file};
          ansible-playbook -u ${var.user_name} --private-key ${local_file.key.filename} -i ${var.master_node_inventory_file} ${var.master_node_config_file}
     EOT
  }

  tags = merge(local.common_tags, tomap({ Name = "k8s-master-node" }))

  depends_on = [aws_key_pair.key_file]
}

#WordPress Installation

resource "null_resource" "wordpress" {
  connection {
    user        = var.user_name
    private_key = tls_private_key.private_key.private_key_pem
    host        = aws_instance.main.public_ip
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.user_name} --private-key ${local_file.key.filename} -i ${var.master_node_inventory_file} ${var.wordpress_installation_file}"
  }

  depends_on = [aws_instance.worker]
}
