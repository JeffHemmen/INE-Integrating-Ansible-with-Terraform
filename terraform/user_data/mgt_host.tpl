#!/bin/bash

sudo apt-get update

### Install Ansible with Python 2.7
# sudo apt-get install software-properties-common
# sudo apt-add-repository --yes --update ppa:ansible/ansible
# sudo apt-get install ansible
#sudo /usr/bin/pip install boto3


### Install Ansiblewith Python 3
sudo apt-get install python3-pip -y
sudo pip3 install ansible boto boto3
