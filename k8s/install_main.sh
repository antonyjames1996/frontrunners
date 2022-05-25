#!/bin/bash

# Run the following scripts as sudo
echo "Script to Install Kubernetes"

sudo apt-get update
sudo apt-get upgrade

# To install the docker 
# Caution: This will install the latest version of Docker
# So it might install different latest versions of docker
# if installed at different times.
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo rm get-docker.sh

#Installing the container runtime
# Since the version 1.24 Docker engine default support was
#removed from the kubelet. We need to install the default continer runtime interface 
#CRI by ourselves.
# We will install cri-dockerd as our CRI
# https://github.com/Mirantis/cri-dockerd

# https://kubernetes.io/blog/2020/12/02/dont-panic-kubernetes-and-docker/
# Docker produces isn’t really a Docker-specific image—it’s an OCI (Open Container Initiative) image. 
#Any OCI-compliant image, regardless of the tool you use to build it, will look the same to Kubernetes. 
#Both containerd and CRI-O know how to pull those images and run them. 
#This is why we have a standard for what containers should look like.

#https://thenewstack.io/how-to-deploy-kubernetes-with-kubeadm-and-containerd/


#Installing kubernetes
# Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl






# Disable Swap
sudo swapoff -a


