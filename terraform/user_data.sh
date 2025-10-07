#### Install and Setup JDK ####

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y openjdk-17-jdk wget unzip curl git

#### Install Jenkins ####
wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

#### Install Docker ####
sudo apt update -y
sudo apy install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker

# ===== Install Node.js for Minification =====
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g minify

# ===== Clean up =====
rm -rf awscliv2.zip
echo "✅ Jenkins, Docker, Node.js, and AWS CLI installed successfully.