#!/bin/bash

# Define the image name and tag
IMAGE_NAME="reactjs-demo"
IMAGE_TAG="latest"

# Check if a container with the given image name and tag is running
if [ "$(docker ps -q -f name=$IMAGE_NAME -f ancestor=$IMAGE_NAME:$IMAGE_TAG)" ]; then
  echo "A container with the specified image name and tag = $IMAGE_NAME:$IMAGE_TAG is running, so bring it down using docker-compose"
  docker-compose down
  echo "Docker container is stopped and removed."
else
  # No running container found with the specified image name and tag
  echo "No Docker container with the name $IMAGE_NAME:$IMAGE_TAG is currently running."
fi

# Check if the Docker image exists without displaying the detailed output
if docker image inspect "$IMAGE_NAME:$IMAGE_TAG" &> /dev/null; then
  echo " "
  echo "$IMAGE_NAME:$IMAGE_TAG image exists"
  echo "Deploying the container using docker-compose"
  echo " "
  docker-compose up -d
  echo ""
  # Display a success message in green color
  echo -e "\e[32mDocker container is up and running.\e[0m"

  # Display all running containers
  docker ps

  # Display the public IP
  # Use green color for the URL
  echo -e "Please check the container output on the browser IP:PORT - \e[32mhttp://$(curl -s checkip.amazonaws.com):3000\e[0m"
else
  # Image doesn't exist
  echo "No Docker image found with the name and tag = $IMAGE_NAME:$IMAGE_TAG"
  # Display an error message in red color
  echo -e "\e[31m -> Build the image and run the script\e[0m"
fi

