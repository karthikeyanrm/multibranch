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
                    sh 'docker tag reactjs-demo:latest karthikeyanrajan/karthidev:latest'

                    // Display a list of Docker images
                    sh 'docker imagges'
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
            script {
                if (env.BRANCH_NAME == 'dev') {
                    emailext to: 'karthisk217@gmail.com',
                    subject: 'Jenkins Build Successful - Dev Branch',
                    body: 'The build on the dev branch was successful. You can view the build log [here](${BUILD_URL}console)'.toString()
                } else if (env.BRANCH_NAME == 'master') {
                    emailext to: 'karthisk217@gmail.com',
                    subject: 'Jenkins Build Successful - Master Branch',
                    body: 'The build on the master branch was successful. You can view the build log [here](${BUILD_URL}console)'.toString()
                }
            }
        }
        failure {
            script {
                if (env.BRANCH_NAME == 'dev') {
                    emailext to: 'karthisk217@gmail.com',
                    subject: 'Jenkins Build Failed - Dev Branch',
                    body: 'The build on the dev branch has failed. You can view the build log [here](${BUILD_URL}console)'.toString(),
                    attachLog: true
                } else if (env.BRANCH_NAME == 'master') {
                    emailext to: 'karthisk217@gmail.com',
                    subject: 'Jenkins Build Failed - Master Branch',
                    body: 'The build on the master branch has failed. You can view the build log [here](${BUILD_URL}console)'.toString(),
                    attachLog: true
                }
            }
        }
    }
}
