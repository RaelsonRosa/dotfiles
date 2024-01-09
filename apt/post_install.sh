#!/usr/bin/env bash


echo  "Welcome! Let's start post install be patient"

# Test to see if user is running with root privileges.
if [[ "${UID}" -ne 0 ]]
then
 echo 'Must execute with sudo or root' >&2
 exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
C_OFF='\033[0m'        # Reset Color



echo "${BLUE} Install and config docker desktop${C_OFF}"

# docker desktop
# https://docs.docker.com/desktop/linux/install/ubuntu/
# set up the repository
# https://docs.docker.com/engine/install/ubuntu/#set-up-the-repository
sudo apt install -y ca-certificates gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world

# post-installation steps for Linux
# https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker # use on linux -> log out and log back
docker run hello-world
# on Debian and Ubuntu, the Docker service is configured to start on boot by default
sudo systemctl enable docker.service # sudo systemctl disable docker.service
sudo systemctl enable containerd.service # sudo systemctl disable containerd.service

# use the “local” logging driver to prevent disk-exhaustion
# https://docs.docker.com/config/containers/logging/configure/#configure-the-default-logging-driver
sudo nano /etc/docker/daemon.json
# ------------------------------- #
  # {
  #  log-driver": "local"
  # }
# ------------------------------- #
docker info --format '{{.LoggingDriver}}' # should be json-file
sudo sudo systemctl restart docker
docker info --format '{{.LoggingDriver}}' # should be local
docker container prune -f

echo "${BLUE} Install and config kubernets${C_OFF}"

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
sudo -- sh -c 'apt update && apt install kubeadm kubelet kubectl -y'
sudo -- sh -c 'apt-mark hold kubeadm kubelet kubectl'


echo "${BLUE} Install and kind${C_OFF}"
mkdir -p ~/.local/.bin
curl -Lo ~/.local/.bin/kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
chmod +x ~/.local/.bin/kind


echo "${BLUE}Init kind dev cluster ${C_OFF}"
sh -c 'kind create cluster -- <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: kind
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 8080
    protocol: TCP
  - containerPort: 443
    hostPort: 44300
    protocol: TCP
EOF'


echo "${BLUE} Install sdkman${C_OFF}"
#https://www.dio.me/articles/gerenciando-versoes-diferentes-do-java-jdk-com-sdkman-ubuntu
curl -s "https://get.sdkman.io" | bash


echo "${BLUE} Install postman${C_OFF}"
echo 'Installing postamn'
sudo snap install postman


echo "${BLUE} Install visual studio code${C_OFF}"
echo 'Installing Visual Studio Code'
sudo snap install --classic code


echo "${BLUE} Updating and Cleaning Unnecessary Packages${C_OFF}"
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
