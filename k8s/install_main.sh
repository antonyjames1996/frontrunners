#!/bin/bash

# Run the following scripts as sudo
echo "Script to Install Kubernetes"

sudo apt-get update
sudo apt-get upgrade

# To install the docker 
# Caution: This will install the latest version of Docker
# So it might install different latest versions of docker
# if installed at different times.

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo rm get-docker.sh



