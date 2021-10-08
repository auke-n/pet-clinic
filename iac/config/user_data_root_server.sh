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

# Add hosts records
echo "${build_ip} build.server" >> /etc/hosts
echo "${test_ip} test.server" >> /etc/hosts
echo "${web_ip} web.server" >> /etc/hosts

#Install Ansible
amazon-linux-extras install ansible2

aws s3 cp s3://petclinic01/config/ansible/hosts /etc/ansible/

#Copy ansible roles
aws s3 cp s3://petclinic01/ansible.tar.gz /home/ec2-user/
cd /home/ec2-user && tar -xzvf ansible.tar.gz .ansible

#Install git, java, jenkins, docker on servers
cd .ansible
ansible-playbook site.yml

#Restore jenkins directory from backup
aws s3 cp s3://petclinic01/jenkins.tar.gz .
tar -xzvf jenkins.tar.gz /

##########################################
#Server command prompt customization     #
##########################################
# PS1
echo '' >> /etc/bashrc
echo '# Command prompt customization - $PS1' >> /etc/bashrc
echo 'if [ "`id -u`" -eq 0 ]; then' >> /etc/bashrc
echo '    PS1="\[$(tput bold)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]manager\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'else' >> /etc/bashrc
echo '    PS1="\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]manager\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'fi' >> /etc/bashrc
# Handy aliases
echo 'alias ..="cd .."' >> /etc/bashrc
echo 'alias ..2="cd ../.."' >> /etc/bashrc
echo 'alias ..3="cd ../../.."' >> /etc/bashrc