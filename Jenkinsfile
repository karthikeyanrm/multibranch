pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIAL_ID = 'DOCKER_HUB_CREDENTIAL_ID'
    }

    stages {
        stage('Prepare and Deploy') {
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

                    // Grant execute permission to the script
                    sh 'chmod +x containercheckscript.sh'

                    // Call the external script to check the container state
                    sh './containercheckscript.sh'

                    // Pull the image
                    sh 'docker pull karthikeyanrajan/dev:latest'

                    // Run the container
                    sh 'docker run -d -p 80:80 --name reactjscontainer karthikeyanrajan/dev:latest'
                }
            }
        }
    }
}
