##########################
#Jenkins Configuration
##########################

locals {
 ec2_tags = {  
   Name = "JenkinsServer"
   CreatedBy = "Kiran Peddineni"
 }
}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.jenkins_key.key_name
  security_groups = [aws_security_group.jenkins.id]

  subnet_id = var.subnet_ids

  connection {
    type        = "ssh"
    user        = var.user_name
    host        = self.public_ip
    private_key = tls_private_key.access_key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get update && sudo apt-add-repository ppa:ansible/ansible -y && sudo apt-get update && sleep 15 && sudo apt install ansible -y"]
  }

  provisioner "local-exec" {
    command = <<EOT
        sleep 30;
        >jenkinshost;
        echo "[jenkins]" | tee -a jenkinshost;
        echo "${self.public_ip} ansible_user=${var.user_name} ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_python_interpreter=/usr/bin/python3" | tee -a jenkinshost;
        ansible-playbook -u ${var.user_name} --private-key ${local_file.key_file.filename} -i jenkinshost install-jenkins.yml
       EOT
  }

  tags = local.ec2_tags
}
