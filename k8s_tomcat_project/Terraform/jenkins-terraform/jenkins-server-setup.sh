#Setting up terraform.. One time set up
wget https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip

sleep 5

sudo apt install unzip -y

sleep 5

unzip terraform_0.12.9_linux_amd64.zip

rm terraform_0.12.9_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version

#Setting up Aws Cli.. One time set up
sudo apt install python3-pip -y
sleep 5

pip3 install --upgrade --user awscli
sleep 5

echo "export PATH=/home/ec2-user/.local/bin:$PATH" | tee -a ~/.bashrc
sleep 5

sudo apt-get install awscli -y
sleep 2

aws --version
