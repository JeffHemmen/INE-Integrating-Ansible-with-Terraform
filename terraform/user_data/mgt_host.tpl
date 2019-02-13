#!/bin/bash

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND
sudo apt-get update
sudo apt-get upgrade -y

### Install Ansible with Python 2.7
# sudo apt-get install software-properties-common
# sudo apt-add-repository --yes --update ppa:ansible/ansible
# sudo apt-get install ansible

### Install Ansiblewith Python 3
sudo apt-get install python3-pip -y
sudo pip3 install ansible


### Install boto3 for RDS instances in dynamic inventory
sudo /usr/bin/pip install boto3
