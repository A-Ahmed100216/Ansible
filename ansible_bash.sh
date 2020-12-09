# Install Ansible
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Install Python and dependencies
sudo apt install python -y
sudo apt install python-pip -y
sudo pip install --upgrade pip -y

# Installing AWS Command Line Interface
pip3 install awscli
sudo pip install boto -y
sudo pip install boto3 -y

# Optional extras
  # View file tree
sudo apt install tree
  # Change name of virtual machine (easy to confuse IPs)
sudo hostnamectl set-hostname new_name
sudo reboot
