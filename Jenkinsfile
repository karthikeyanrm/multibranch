pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL_ID = 'DOCKER_HUB_CREDENTIAL_ID'
    }

    stages {
        stage('Build and Tag') {
            steps {
                script {
                    // Build Docker Compose
                    sh 'docker-compose build'

                    // Tag the image
                    sh 'docker tag reactjs-demo:latest karthikeyanrajan/dev:latest'
                }
            }
        }

        stage('Push and Clean Up') {
            steps {
                script {
                    // Log in to Docker Hub
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIAL_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    }

                    // Push the image
                    sh 'docker push karthikeyanrajan/dev:latest'

                    // Remove local images
                    sh 'docker rmi -f reactjs-demo:latest'
                    sh 'docker rmi -f karthikeyanrajan/dev:latest'
                }
            }
        }

        stage('Check and Cleanup') {
            steps {
                script {
                    // Check if the container is running
                    def isContainerRunning = sh(script: 'docker ps -q -f name=reactjscontainer', returnStatus: true) == 0

                    if (isContainerRunning) {
                        echo 'A container with the name "reactjscontainer" is running. Stopping and removing it.'
                        sh 'docker stop reactjscontainer'
                        sh 'docker rm reactjscontainer'
                    } else {
                        echo 'No running container with the name "reactjscontainer" found.'
                    }

                    // Pull the image
                    sh 'docker pull karthikeyanrajan/dev:latest'

                    // Run the container
                    sh 'docker run -d -p 80:80 --name reactjscontainer karthikeyanrajan/dev:latest'
                }
            }
        }
    }
}
