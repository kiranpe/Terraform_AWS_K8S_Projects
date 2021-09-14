#Worker Nodes Configuration

resource "aws_instance" "worker" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.disk_type
  key_name      = aws_key_pair.key_file.key_name

  subnet_id = data.aws_subnet.filtered_subnet.id

  count = 2

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
      sleep 30;
      > ${var.worker_node_inventory_file};
      echo "[k8sworker]" | tee -a ${var.worker_node_inventory_file};
      echo "${self.public_ip} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a ${var.worker_node_inventory_file};
      cat ${var.master_node_inventory_file} | tee -a ${var.worker_node_inventory_file};
      ansible-playbook -u ${var.user_name} --private-key ${local_file.key.filename} -i ${var.worker_node_inventory_file} ${var.worker_node_config_file}
    EOT
  }

  depends_on = [aws_instance.main]

  tags = merge(local.common_tags, tomap({ Name = "k8s-worker-node-${count.index}" }))
}
