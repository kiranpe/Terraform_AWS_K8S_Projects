module "jenkins" {
  source = "./modules/jenkins"
}

output "jenkins_instance_ip" {
  value = module.jenkins.instance_ip
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}
