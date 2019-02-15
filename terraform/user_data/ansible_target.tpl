#!/bin/bash

apt-get update

apt-get install python3 python3-pip -y

useradd ansible -s /bin/bash
mkdir -p ~ansible/.ssh
echo "${ansible_public_key}" > ~ansible/.ssh/authorized_keys
chmod 400 ~ansible/.ssh/authorized_keys
chown -R ansible: ~ansible

# Give ansible user sudo permissions w/o password prompt
echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible
chmod 0440 /etc/sudoers.d/ansible
