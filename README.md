# Jenkins-Ansible-Terraform

This project describes about deploying terraform resources using ansible & jenkins pipeline.

roles/terraform/tasks/main.yml- This file invokes the `terraform` module in ansible and applies the ./terraform_scripts.

templates/variables.tf.j2- Ansible uses Jinja2 templating to enable dynamic expressions and access to variables. This is the file used to subsitute the values of variables in terraform.

Jenkinsfile- This is the pipeline in declarative style with choice parameters that are setup in this file to accept user inputs and pass this on to the ansible playbook declared in shell.

backend.tf - This is the file which is helping us to store the terraform state on to s3 bucket mentioned in the confuguration. 

infra.tf - This file contains details all about the infra we are planning to create on AWS.

output.tf - This file helps us to capture the output of the resources we want to show that are successfully created.

tf-stack.yml- This is the file which orchestrates the deployment by using the terraform role for ansible.
