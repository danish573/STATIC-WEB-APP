#!/bin/bash
set -e

echo "===== Updating System ====="
sudo apt update -y && sudo apt upgrade -y

echo "===== Installing Dependencies (JDK, Git, Curl, Wget, Unzip) ====="
sudo apt install -y openjdk-17-jdk wget unzip curl git

echo "===== Installing Jenkins ====="
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install -y jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins


echo "===== Installing Docker ====="
sudo apt install -y docker.io
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

echo "===== Installing Node.js (for minification) ====="
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g minify

echo "===== Installing AWS CLI (Optional) ====="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

echo "✅ Jenkins, Docker, Node.js, and AWS CLI installed successfully."
echo "➡️ Access Jenkins at: http://<your-server-ip>:8080"
echo "➡️ Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
