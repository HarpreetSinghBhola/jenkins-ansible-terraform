pipeline {
    agent any 
    parameters {

         string(
              name: 'VPC_Name',
              defaultValue: 'HarpreetVPC',
              description: 'Name of the VPC',
              trim: 'true')
        
        string(
              name: 'Instance_Name',
              defaultValue: 'TerraInstance',
              description: 'Name of the instance',
              trim: 'true')

          choice(
              name: 'Terraform_State',
              choices: "absent\npresent",
              description: 'Select to present for creating the stack or absent to delete it')
        
    }
    options {
        timeout(time: 2, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '100'))
    }
     stages {
        stage('Dry Run') {
            steps {
                Cleanup()
		checkout scm
		sh "git clean -xdf"
                echo 'Excecuting a dry run..'
                sh 'ansible-playbook -vvvv --inventory=/etc/ansible/hosts -e state=${Terraform_State}  -e vpc_name=${VPC_Name} -e instance_name=${Instance_Name} tf-stack.yaml --check'
            }
        }
        stage('Waiting for User Approval') {
            steps {
              script {
                        env.USER_INPUT = input message: 'Select your Action!',
                            parameters: [choice(name: 'Apply Terraform?', choices: 'no\nyes', description: 'Choose "yes" if you want to apply this plan or "no" to cancel it')]
                      }
            }
        }
        stage('Deploying Stack') {
          when {
            environment name: 'USER_INPUT', value: 'yes'
            }
            steps {
                echo 'Excecuting Terraform Apply..'
                sh 'ansible-playbook -vvvv --inventory=/etc/ansible/hosts -e state=${Terraform_State}  -e vpc_name=${VPC_Name} -e instance_name=${Instance_Name} tf-stack.yaml'

            }
        }
    }

    post {
        always {
            node('') { // Allocates any node that is available.
                echo "Do e.g. cleanup steps here"
            }
        }
    }
}

def Cleanup() {
	echo "Cleaning up"
	sh """#!/bin/bash
		sudo rm -rf *
		sudo rm -rf .*
		ls -a
	"""
	echo "End of cleanup"
}
