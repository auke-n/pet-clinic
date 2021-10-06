#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo yum update -y

#Create a SWAP-file
sudo su
dd if=/dev/zero of=/swapfile count=3072 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
swapon  /swapfile
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
mount -a

#Add jenkins user

sudo useradd -d /var/lib/jenkins jenkins
echo "jenkins ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers