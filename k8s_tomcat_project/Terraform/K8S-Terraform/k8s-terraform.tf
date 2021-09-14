provider "aws" {
   region = "us-east-2"
 }

variable "private_key" {
  default = "./keyfile.pem"
 }

variable "ansible_user" {
  default = "ubuntu"
}

resource "aws_instance" "jenkins" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.micro"
  security_groups = ["k8scluster"]
  key_name = "k8skey"
  
  connection {
      user        = "${var.ansible_user}"
      private_key = "${file(var.private_key)}"
      host = "${aws_instance.jenkins.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname jenkins"]
  }

  # This is where we configure the instance with ansible-playbook
  # Jenkins requires Java to be installed
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
          >hostfiles/java;
          echo "[java]" | tee -a hostfiles/java;
          echo "${aws_instance.jenkins.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/java;
          ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/java install-java.yaml
    EOT
  }

  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/jenkins;
      echo "[jenkins-ci]" | tee -a hostfiles/jenkins;
      echo "${aws_instance.jenkins.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/jenkins;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/jenkins install-jenkins.yaml
    EOT
  }

  tags = {
    Name = "jenkins-instance"
  }
  
  depends_on = [ "aws_instance.workernode" ]
}

resource "aws_instance" "masternode" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"
  security_groups = ["k8scluster"]
  key_name = "k8skey"
  
  connection {
      user        = "${var.ansible_user}"
      private_key = "${file(var.private_key)}"
      host = "${aws_instance.masternode.public_ip}"
  }
  
  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname master-node"]
  } 
  
  # This is where we configure the instance with ansible-playbook
  # install K8S on master node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/masterhost;
      echo "[k8s-master]" | tee -a hostfiles/masterhost;
      echo "${aws_instance.masternode.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/masterhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/masterhost k8s-master-node-installation.yaml
    EOT
  }
 
  tags = {
    Name = "master-node"
  }
}

resource "aws_instance" "workernode" {
  ami           = "ami-05c1fa8df71875112"
  instance_type = "t2.medium"
  security_groups = ["k8scluster"]
  key_name = "k8skey"

  connection {
      user        = "${var.ansible_user}"
      private_key = "${file(var.private_key)}"
      host = "${aws_instance.workernode.public_ip}"
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt-get install -f ansible -y && sudo hostnamectl set-hostname worker-node"]
  }

  # This is where we configure the instance with ansible-playbook
  # install K8S on worker node
  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      >hostfiles/workerhost;
      echo "[k8s-worker]" | tee -a hostfiles/workerhost;
      echo "${aws_instance.workernode.public_ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no'" | tee -a hostfiles/workerhost;
      cat hostfiles/masterhost | tee -a hostfiles/workerhost;
      ansible-playbook -u ${var.ansible_user} --private-key ${var.private_key} -i hostfiles/workerhost k8s-worker-node-installation.yaml
    EOT
  }

  tags = {
    Name = "worker-node"
  }
  depends_on = [ "aws_instance.masternode" ]
}

output "ec2_masternode_publicip" {
  value = "${aws_instance.masternode.public_ip}"
}

output "ec2_workernode_publicip" {
  value = "${aws_instance.workernode.public_ip}"
}

output "ec2_jenkins_server_publicip" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "jenkins-url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}
