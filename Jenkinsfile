pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL_ID = 'kndocker' // Updated credential ID
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Build Docker Compose
                    sh 'docker-compose build'
                    sh 'docker images'
                    // Tag the image
                    sh 'docker tag reactjs-demo:latest karthikeyanrm/prodrepo:latest'

                    // Log in to Docker Hub securely
                    withCredentials([
                        usernamePassword(credentialsId: DOCKER_HUB_CREDENTIAL_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'MY_SECURE_PASSWORD')]) {
                        sh "echo \$MY_SECURE_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                        sh 'docker push karthikeyanrm/prodrepo:latest'
                    }

                    // Remove local images
                    sh 'docker rmi -f reactjs-demo:latest'
                    sh 'docker rmi -f karthikeyanrm/prodrepo:latest'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
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
                    sh 'docker pull karthikeyanrm/prodrepo:latest'

                    // Run the container
                    sh 'docker run -d -p 80:80 --name reactjscontainer karthikeyanrm/prodrepo:latest'
                }
            }
        }
    }

    post {
        success {
            script {
                emailext to: 'karthisk217@gmail.com',
                subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS',
                body: """The build #${BUILD_NUMBER} was successful. You can view the build log [here](${BUILD_URL}console).

Docker Container Info:
${sh(script: 'docker ps --format "{{.Names}}\\t{{.Ports}}" | awk -F "\\t" -v public_ip=$(curl -s ifconfig.me) \'{print "Container:", $1, "Public IP:", public_ip, "Port Mapping:", $2}\'', returnStdout: true)}
""",
                attachLog: true // Attach build log for success email
            }
        }
        failure {
            script {
                emailext to: 'karthisk217@gmail.com',
                subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS',
                body: "The build #${BUILD_NUMBER} has failed. You can view the build log [here](${BUILD_URL}console)".toString(),
                attachLog: true // Attach build log for failure email
            }
        }
        always {
            // Log out from Docker Hub
            sh 'docker logout'
        }
    }
}
