#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

amazon-linux-extras install epel -y
yum update -y

#Create a SWAP-file
dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
chmod 600 /swapfile
mkswap /swapfile
swapon  /swapfile
echo "/swapfile   swap    swap    sw  0   0" >> /etc/fstab
mount -a

#Install Ansible

amazon-linux-extras install ansible2

#Copy ansible roles

aws s3 cp s3://petclinic01/.ansible /root/.ansible --recursive

#Configure Ansible inventory

echo "[root-server]
jenkins.iplatinum.pro

[build-server]
#ip address of the build-server

[test-server]
#ip address of the test-server

[web-server]
petclinic.iplatinum.pro" >> /etc/ansible/hosts

#Install git, java, jenkins, docker on servers

cd /root/.ansible
ansible-playbook site.yml


#Restore jenkins directory from backup

aws s3 cp s3://petclinic01/jenkins /var/lib/jenkins --recursive


#echo "10.1.1.155  prod-srv" >> /etc/hosts

#aws s3 cp s3://bucketname/config/site.yml .

#Run playbook


