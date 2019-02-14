#!/bin/bash

apt-get update

apt-get install python3 python3-pip -y
/usr/bin/pip3 install ansible boto boto3

useradd ansible -s /bin/bash
usermod -G wheel ansible
mkdir -p ~ansible/.ssh
echo "${ansible_public_key}" > ~ansible/.ssh/authorized_keys
chmod 400 ~ansible/.ssh/authorized_keys
chown -R ansible: ~ansible
