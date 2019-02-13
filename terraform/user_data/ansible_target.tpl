#!/bin/bash

yum update  -y
yum install -y python

useradd ansible
usermod -G wheel ansible
mkdir -p ~ansible/.ssh
echo "${ansible_public_key}" > ~ansible/.ssh/authorized_keys
chmod 400 ~ansible/.ssh/authorized_keys
chown -R ansible: ~ansible/.ssh
