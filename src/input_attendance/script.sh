#!bin/bash

sudo yum update

sudo yum install -y git

sudo git clone https://github.com/tanakalucky/input-attendance-service

cd input-attendance-service

sudo dnf install -y docker

sudo systemctl start docker

sudo docker build . -t input-attendance-image
