#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y

# # Java installation
# sudo amazon-linux-extras enable corretto8
# sudo yum install java-1.8.0-amazon-corretto-devel git -y

# Docker installation
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# #Add jenkins user
# sudo useradd -d /var/lib/jenkins jenkins
# echo "jenkins ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
