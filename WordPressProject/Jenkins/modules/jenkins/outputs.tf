#OutPut Values Configuration

output "instance_ip" {
  value = local.public_ip
}

output "jenkins_url" {
  value = "http://${local.public_dns}:8080"
}
