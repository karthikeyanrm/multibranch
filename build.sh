#!/bin/bash

# Set the name of the Docker image and tag
IMAGE_NAME="reactjs-demo"
IMAGE_TAG="latest"

# Build the Docker image
echo -e "\e[32m Docker image build is started \e[0m"
echo " "
docker compose build  

# Check if the build was successful
if [ $? -eq 0 ]; then
  echo -e "\e[32mDocker image build successful: $IMAGE_NAME:$IMAGE_TAG\e[0m"
else
  echo -e "\e[31mDocker image build failed\e[0m"
exit 1
fi

#Show the docker images
echo "                     ###Docker Images###"
docker images
