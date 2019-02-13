#!/bin/bash

yum update  -y
yum install -y python python-pip ansible

/usr/bin/pip install boto3
