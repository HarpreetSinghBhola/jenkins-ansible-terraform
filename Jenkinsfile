pipeline {
    agent any 
    
    parameters {
        choice(
              name: 'Cloud_Provider',
              choices: "aws\ndocker\ngce",
              description: 'Name the cloud provider where you would like to deploy.')

              choice(
                  name: 'aws_region',
                  choices: "eu-west-1\neu-west-2\nus-east-1",
                  description: 'Name the region where you would like to deploy. This is to demonstrate the ability to set backend configuration during runtime')

          string(
              name: 'Instance_Name',
              defaultValue: 'foo-instance',
              description: 'Name of the instance you would like to launch.',
              trim: 'false')

          choice(
              name: 'Terraform_State',
              choices: "absent\npresent",
              description: 'Specify whether you want to APPLY(present) or DESTROY(absent) the Terraform implementation.')
        
    }
    options {
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '100'))
    }
    stages {
        stage('Build') {
            agent {
                label 'ubuntu'
            }
            steps {
                checkout scm
                //sh "build.sh"
                script {
                    echo "Put other 'scripts', or e.g. own functions to call here."
                }
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

