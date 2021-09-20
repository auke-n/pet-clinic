#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y

# Java and Git installation
sudo amazon-linux-extras enable corretto8
sudo yum install java-1.8.0-amazon-corretto-devel git -y

#Create a SWAP-file
sudo su
dd if=/dev/zero of=/swapfile count=3072 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
swapon  /swapfile
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
mount -a

#Install Ansible

amazon-linux-extras install ansible2

#Install Ansible roles: java, jenkins, docker, pip, git

#ansible-galaxy install geerlingguy.jenkins
ansible-galaxy install geerlingguy.java
# ansible-galaxy install geerlingguy.pip
# ansible-galaxy install geerlingguy.docker
ansible-galaxy install geerlingguy.git

echo "---
- hosts: localhost
  become: true
  vars:
    java_packages:
       - java-1.8.0-openjdk
  roles:
    - role: geerlingguy.java
    - role: geerlingguy.git" > site.yml

#Run playbook
ansible-playbook site.yml

#Add jenkins user

sudo useradd -d /var/lib/jenkins jenkins
echo "jenkins ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Docker installation
amazon-linux-extras install docker -y
usermod -a -G docker jenkins
systemctl start docker
systemctl enable docker
