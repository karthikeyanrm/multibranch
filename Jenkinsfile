pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Execute Commands Based on Branch') {
            when {
                expression { env.BRANCH_NAME == 'dev' }
            }
            steps {
                script {
                    // Build the Docker containers using Docker Compose
                    sh 'docker compose build'

                    // Tag the Docker image
                    sh 'docker tag nginx:latest karthikeyanrajan/karthidev:latest'

                    // Display a list of Docker images
                    sh 'docker images'
                }
            }
        }
        stage('Execute Commands for Master Branch') {
            when {
                expression { env.BRANCH_NAME == 'master' }
            }
            steps {
                script {
                    // Run 'ls -al' for the master branch
                    sh 'ls -al'
                }
            }
        }
    }
    post {
        success {
            emailext to: 'karthisk217@gmail.com',
            subject: 'Jenkins Build Successful',
            body: 'The build was successful. You can view the build log [here](${BUILD_URL}console)'.toString()
        }
        failure {
            emailext to: 'karthisk217@gmail.com',
            subject: 'Jenkins Build Failed',
            body: 'The build has failed. You can view the build log [here](${BUILD_URL}console)'.toString(),
            attachLog: true
        }
    }
}
