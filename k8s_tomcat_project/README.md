#Devops Project
------------------------------------------------------------------------------------------------
| Tools:                                                                                       |
| ------                                                                                       |
|                                                                                              |
| Cloud: AWS EC2, Cloud--Orchestration: Terraform                                              |
|                                                                                              |
| Container: Docker, Container-Orchestration: Kubernetes, Env-Automation: Ansible                |
|                                                                                              |
| Source Code Repo: GIT, CI: Jenkins                                                           |
|                                                                                              |
| Coding: HTML + CSS, Scripting: Shell Script                                                  |
------------------------------------------------------------------------------------------------

Manual Set Up:
------------------
You need Three instances.. One for Master Node, One for Worker Node and One for Jenkins server

Choose t2.medium Ubuntu Instances for K8S set up and t2.micro for jenkins

Follow kuberenetes-master-worker file to set up K8S after lanching ubuntu instances.. File is in K8SSetup folder

Follow security group instructions 

Keep your rsa or aws pem file under ymlfiles folder to use for ansible ssh and update hosts file with correct values

Set up jenkins build with git repo and add below lines to execute shell commands

Basic (Jenkins + Docker + Ansible):
------------------------------------
#create image and testing it out if image is fine or not

sh "$WORKSPACE"/dockerscript.sh

#change permissions for key file first

chmod 600 "$WORKSPACE"/ymlfiles/your rsa key file or your pem file

#deploying casestudy image and doing healthcheck

ansible-playbook "$WORKSPACE"/ymlfiles/casestudy.yaml -i "$WORKSPACE"/ymlfiles/hosts

application access

http://<target_ip>:<nodeport>/casestudy/login.html

Note: you can get Nodeport from jenkins build or from K8S dashboard. 

Manual + Automation using Ansible:
-----------------------------
Automated k8s MASTER Node set up using ansible.. File is available under K8SSetup folder.. 

Login in to masternode box and install ansible first:

sudo apt-get update

sudo apt-get install ansible -y

Then download yml and hosts.. update hosts file with your IP's and key file and run yml file central server(Central server is always preferable option.. in my case Jenkins sever)

ex:
ansible-playbook k8s-master-node-installation.yml -i hosts

Automated k8s WORKER Node set up using ansible.. File is available under K8SSetup folder.. 

Login in to workernode box and install ansible first:

sudo apt-get update

sudo apt-get install ansible -y

Then download yml and hosts.. update hosts file with your IP's and key file and run yml file from central server(Central server is always preferable option)

ex:
ansible-playbook k8s-worker-node-installation.yml -i hosts

Complete Automation using Terraform:
-------------------------------------
Automated creation of EC2 instance and Installing Java, Jenkins, Docker, K8S and Ansible using Terraform.. No Manual interaction.. Notes and Files are available under Terraform folder..

Upcoming:
-----------
Going Set up builds and deploy image on k8s.. Manual Interaction.. Soon......
