#!/bin/bash

apt-get update
apt-get install -y docker.io
apt install -y docker-compose-plugin

usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker