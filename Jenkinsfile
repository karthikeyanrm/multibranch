pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL_ID = 'DOCKER_HUB_CREDENTIAL_ID'
    }

    stages {
        stage('Build and Deploy') {
            steps {
                script {
                    // Build Docker Compose
                    sh 'docker-compose build'

                    // Tag the image
                    sh 'docker tag reactjs-demo:latest karthikeyanrajan/dev:latest'

                    // Log in to Docker Hub securely
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIAL_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh 'docker push karthikeyanrajan/dev:latest'
                    }

                    // Remove local images
                    sh 'docker rmi -f reactjs-demo:latest'
                    sh 'docker rmi -f karthikeyanrajan/dev:latest'

                    // Check if any containers with the name "reactjscontainer" are either exited or running
                    containers_to_remove = sh(script: '''
#!/bin/bash

# Check if any containers with the name "reactjscontainer" are either exited or running
containers_to_remove=$(docker ps -q --filter "name=reactjscontainer" --filter "status=exited" --filter "status=running")

if [ -n "$containers_to_remove" ]; then
  echo "Found exited and/or running containers with the name 'reactjscontainer':"
  echo "$containers_to_remove"

  # Stop and forcefully remove the containers
  docker stop $containers_to_remove
  docker rm -f $containers_to_remove

  echo "Containers with the name 'reactjscontainer' have been removed."
else
  echo "No exited or running containers with the name 'reactjscontainer' found. Proceeding to the next step."
fi
''', returnStdout: true).trim()

                    // Pull the image
                    sh 'docker pull karthikeyanrajan/dev:latest'

                    // Run the container
                    sh 'docker run -d -p 80:80 --name reactjscontainer karthikeyanrajan/dev:latest'
                }
            }
        }
    }
}
