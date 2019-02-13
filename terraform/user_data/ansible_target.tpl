#!/bin/bash

apt-get update
apt-get dist-upgrade -y

useradd ansible -s /bin/bash
usermod -G wheel ansible
mkdir -p ~ansible/.ssh
echo "${ansible_public_key}" > ~ansible/.ssh/authorized_keys
chmod 400 ~ansible/.ssh/authorized_keys
chown -R ansible: ~ansible
