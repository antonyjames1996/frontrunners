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


# Link here : https://github.com/containerd/containerd/blob/main/docs/getting-started.md#step-3-installing-cni-plugins
#Step 1: Installing containerd
curl https://github.com/containerd/containerd/releases/download/v1.6.4/containerd-1.6.4-linux-amd64.tar.gz

tar Cxzvf /usr/local containerd-1.6.4-linux-amd64.tar.gz

# Step 2: Installing runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.2/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

# Step 3: Installing CNI plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz


#Initializing your control-plane node with pod networking using Calico
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Install Calico   https://projectcalico.docs.tigera.io/getting-started/kubernetes/quickstart
# Install the Tigera Calico operator and custom resource definitions.
kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml

# Install Calico by creating the necessary custom resource. For more information on configuration options available in this manifest, see the installation reference.
kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

# Confirm that all of the pods are running with the following command.
watch kubectl get pods -n calico-system

# Wait until each pod has the STATUS of Running.
# Note: The Tigera operator installs resources in the calico-system namespace. Other install methods may use the kube-system namespace instead.



# Disable Swap
sudo swapoff -a


