#Terraform
------------

Do the terraform set up.. follow my notes terraform_setup

Download .tf and yaml files to your local

I am setting up jenkins and running K8S set up from jenkins.. having host files dependency to deploy image on workernode

Jenkins folder:
----------------
This folder is to set up jenkins ci server.

Go to jenkins folder and run below to set up jenkins instance

terraform init 

terraform plan 

Once your plan is shows up cleanly then go a head and run apply otherwise fix the issue.

terraform apply or terraform apply -auto-approve

This will create ec2 and install java, jenkins , Terraform and awscli and Adds the below line to sudoers file.

jenkins  ALL=(ALL)  NOPASSWD: ALL

Use rsa key instead of pem file if you want.. below is the process

Manual Task on Jenkins: 

For now only Manual task in Jenkins is configuring aws credentials (Try to find a way to automate)

Login to Jenkins box and do below

sudo su - jenkins

aws configure

It will ask for key deatials and enter them and then set up below kubernetes 

Adding Jenkins user to root was Automated with ansible.. still if you want to add it manually follow below process and remove ansible task for install jenkins yaml file..

sudo visudo

jenkins  ALL=(ALL)  NOPASSWD: ALL

Create rsa key:(you can use your pem file but you can do in this as well)

ssh-keygen -t rsa

copy iy to remote server using .pem file

cat .ssh/id_rsa.pub | ssh ubuntu@public ip -i your key.pem 'cat >> .ssh/authorized_keys'

Use id_rsa key to login to servers

ssh -i ~/.ssh/id_rsa ubuntu@public ip

K8SSetup folder: 
------------------
Afer cloning repo just go to this repo and type following or setup Jenkins build like below after jenkins installation is done..

cd "$WORKSPACE"/Terraform/K8S-Terraform

chmod 600 keyfile.pem (very imp.. otherwise key dosen't work)

terraform init 

sleep 5

terraform plan 

sleep 5

terraform apply -auto-approve (terrafor apply --> asks for yes or no condition)

k8s-terraform.tf file will lanuch your ec2 instances and will install ansible and k8s.
This will take arround 10-15mins.

Kubernetes folder:
--------------------
If you want to Provision your ec2 individually.. then use these tf files
Afer cloning repo go to this repo
  masternode folder:
     This tf file for setting up masternode
  workernode:
     THis tf file is for setting up workernode
 
work in progress......
 
Note: Set Up phase is completed.. Now Targeting Deploy Phase and Few more things are like java set up diff and kubernetes indidual node set ups.. working on them..
------------------------------------------------------------------------------------------------------------
