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

#Install Ansible roles: java, jenkins, docker, pip, git

ansible-galaxy install geerlingguy.jenkins
ansible-galaxy install geerlingguy.java
#ansible-galaxy install geerlingguy.pip
#ansible-galaxy install geerlingguy.docker
#ansible-galaxy install geerlingguy.git

echo "---
- hosts: localhost
  become: true
  vars:
    java_packages:
       - java-1.8.0-openjdk
  roles:
    - role: geerlingguy.java
    - role: geerlingguy.jenkins" > site.yml

sed -i 's/\[\]/\[ace-editor, ant, antisamy-markup-formatter, ant, apache-httpcomponents-client-4-api, bootstrap4-api, bootstrap5-api, bouncycastle-api, branch-api, build-timeout, caffeine-api, checks-api, cloudbees-folder, command-launcher, credentials, credentials-binding, credentials, display-url-api, durable-task, echarts-api, email-ext, font-awesome-api, git, git-client, github, github-api, github-branch-source, github, git, git-server, gradle, handlebars, jackson2-api, jdk-tool, jjwt-api, jquery3-api, jsch, junit, ldap, locale, lockable-resources, mailer, matrix-auth, matrix-project, momentjs, okhttp-api, pam-auth, pipeline-build-step, pipeline-github-lib, pipeline-graph-analysis, pipeline-input-step, pipeline-milestone-step, pipeline-model-api, pipeline-model-definition, pipeline-model-extensions, pipeline-rest-api, pipeline-stage-step, pipeline-stage-tags-metadata, pipeline-stage-view, plain-credentials, plugin-util-api, popper2-api, popper-api, resource-disposer, scm-api, script-security, snakeyaml-api, ssh-credentials, sshd, ssh-slaves, structs, timestamper, token-macro, trilead-api, workflow-aggregator, workflow-api, workflow-basic-steps, workflow-cps, workflow-cps-global-lib, workflow-cps, workflow-durable-task-step, workflow-job, workflow-multibranch, workflow-scm-step, workflow-step-api, workflow-support, ws-cleanup\]/' /root/.ansible/roles/geerlingguy.jenkins/defaults/main.yml

#sed -i 's/localhost/jenkins.iplatinum.pro/g' /root/.ansible/roles/geerlingguy.jenkins/defaults/main.yml

#sed -r 's|\[([^=[]*)\]|[ace-editor, ant, antisamy-markup-formatter, ant, apache-httpcomponents-client-4-api, bootstrap4-api, bootstrap5-api, bouncycastle-api, branch-api, build-timeout, caffeine-api, checks-api, cloudbees-folder, command-launcher, credentials, credentials-binding, credentials, display-url-api, durable-task, echarts-api, email-ext, font-awesome-api, git, git-client, github, github-api, github-branch-source, github, git, git-server, gradle, handlebars, jackson2-api, jdk-tool, jjwt-api, jquery3-api, jsch, junit, ldap, locale, lockable-resources, mailer, matrix-auth, matrix-project, momentjs, okhttp-api, pam-auth, pipeline-build-step, pipeline-github-lib, pipeline-graph-analysis, pipeline-input-step, pipeline-milestone-step, pipeline-model-api, pipeline-model-definition, pipeline-model-extensions, pipeline-rest-api, pipeline-stage-step, pipeline-stage-tags-metadata, pipeline-stage-view, plain-credentials, plugin-util-api, popper2-api, popper-api, resource-disposer, scm-api, script-security, snakeyaml-api, ssh-credentials, sshd, ssh-slaves, structs, timestamper, token-macro, trilead-api, workflow-aggregator, workflow-api, workflow-basic-steps, workflow-cps, workflow-cps-global-lib, workflow-cps, workflow-durable-task-step, workflow-job, workflow-multibranch, workflow-scm-step, workflow-step-api, workflow-support, ws-cleanup]]|' /root/.ansible/roles/geerlingguy.jenkins/defaults/main.yml


#Run playbook
ansible-playbook site.yml

#sed -i 's/JENKINS_PORT=8080/JENKINS_PORT=8082/g' /etc/sysconfig/jenkins
