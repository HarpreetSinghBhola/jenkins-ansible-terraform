pipeline {
    agent none // Don't allocate a global node this time.
    parameters {
        string(name: 'MY_PARAMETER', defaultValue: "string", description: 'description')
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

