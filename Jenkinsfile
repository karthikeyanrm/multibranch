pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIAL_ID')
    }

    stages {
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build the Docker image using Docker Compose
                    sh 'docker-compose build'

                    // Tag the image with your desired repository and tag
                    sh 'docker tag reactjs-demo:latest karthikeyanrajan/dev:latest'

                    // Push the image to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'DOCKER_HUB_CREDENTIAL_ID', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD"
                        sh 'docker push karthikeyanrajan/dev:latest'
                    }
                }
            }
        }

        stage('Clean Up Local Images') {
            steps {
                sh 'docker rmi -f reactjs-demo:latest && docker rmi -f karthikeyanrajan/dev:latest'
            }
        }

        stage('Pull and Run Docker Image') {
            steps {
                sh 'docker pull karthikeyanrajan/dev:latest'

                // Check if any exited and running containers exist
                script {
                    excited_running_containers = sh(script: 'docker ps -q --filter "status=exited" --filter "status=running"', returnStatus: true).trim()

                    if (excited_running_containers) {
                        echo "Found exited and/or running containers:"
                        echo excited_running_containers

                        // Stop and forcefully remove the containers
                        sh "docker stop $excited_running_containers"
                        sh "docker rm -f $excited_running_containers"

                        echo "Exited and running containers have been removed."
                    } else {
                        echo "No exited or running containers found. Proceeding to the next step."
                    }
                }

                sh 'docker run -d -p 80:80 --name reactjscontainer karthikeyanrajan/dev:latest'
            }
        }
    }
}
