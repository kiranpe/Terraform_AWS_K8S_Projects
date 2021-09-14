#Local Tags and Values Configuration

locals {
  public_ip  = aws_instance.jenkins.public_ip
  public_dns = aws_instance.jenkins.public_dns

  jenkins_tags = {
    Name       = "jenkins-instance"
    CreatedBy  = "Kiran Peddineni"
    Env        = "Non-Prod"
    Maintainer = "Kiran Peddineni"
  }
}
