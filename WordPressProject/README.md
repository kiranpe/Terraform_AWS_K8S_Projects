# WordPressProject

Objective:
----------

--> Create WordPress Site using all new Technologies

    Tools: AWS,Terraform,Docker,K8s,Ansible,Git,Jenkins

About Project:
----------------

   This Project is for configuring a WordPress site. We are going to use all the new technologies to bring up this site.

How To Run:
------------

    Clone main repo if you are setting up this from local and run infra_setup --> k8s_setup --> alb_external.

    If you are setting up this from Jenkins/Azure DevOps, then you need to use branches in this repo. 
    Use infra branch, k8sbranch and albexternal branch to configure. Run them as three seperate builds.
    Order is infra branch --> k8sbranch --> albexternal branch.

<h4>Imp: You need to update "instance_port" variable in alb_external configuration. That port is your k8s NodePort value.</h4>

How To Ref Tag in Module and Run Configuration:
----------------------------------------------
Ex: Infra branch
                                                          
    module "infra" {
      source = "git::https://github.com/kiranpe/WordPressProject.git?ref=v1.4"
    }
