#!/bin/bash

# Check if any containers with the name "reactjscontainer" are either exited or running
containers_to_remove=$(docker ps -q --filter "name=reactjscontainer" --filter "status=exited" --filter "status=running" --filter "status=created")

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
