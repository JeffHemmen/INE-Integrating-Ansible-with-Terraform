#!/bin/bash

apt-get update

### Install Ansible with Python 2.7
# apt-get install software-properties-common
# apt-add-repository --yes --update ppa:ansible/ansible
# apt-get install ansible
# /usr/bin/pip install boto3


### Install Ansiblewith Python 3
apt-get install python3-pip -y
pip3 install ansible boto boto3
