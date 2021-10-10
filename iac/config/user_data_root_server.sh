#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo 'alias ulog="tail -f /var/log/user-data.log"' >> /etc/bashrc

# PS1
echo '' >> /etc/bashrc
echo '# Command prompt customization - $PS1' >> /etc/bashrc
echo 'if [ "`id -u`" -eq 0 ]; then' >> /etc/bashrc
echo '    PS1="\[$(tput bold)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]manager\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'else' >> /etc/bashrc
echo '    PS1="\u\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]@\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;10m\]manager\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]:\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;6m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\] "' >> /etc/bashrc
echo 'fi' >> /etc/bashrc

#=============================================
amazon-linux-extras install epel -y
yum update -y
yum install git -y

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

cd /home/ec2-user/
git clone https://github.com/auke-n/pet-clinic.git
cd ./pet-clinic/iac/config/ansible
cp -r .ansible/roles/* /etc/ansible/roles/
cp -f hosts /etc/ansible/
cp -f ansible.cfg /etc/ansible/
echo "${prv_key}" > /etc/ansible/aws.pem
chmod 400 /etc/ansible/aws.pem

ansible-playbook -i hosts site.yml

