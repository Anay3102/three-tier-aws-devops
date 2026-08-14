#!/bin/bash

set -e

# SYSTEM UPDATE


dnf update -y


# INSTALL DOCKER

dnf install -y docker

systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user



# INSTALL AWS CLI

dnf install -y awscli



# AWS ACCOUNT ID

ACCOUNT_ID=$(aws sts get-caller-identity \
  --query Account \
  --output text \
  --region ${aws_region})


# LOGIN TO AMAZON ECR

aws ecr get-login-password \
  --region ${aws_region} | \
docker login \
  --username AWS \
  --password-stdin \
  "$ACCOUNT_ID.dkr.ecr.${aws_region}.amazonaws.com"



# PULL NODE.JS IMAGE

docker pull \
  "$ACCOUNT_ID.dkr.ecr.${aws_region}.amazonaws.com/${ecr_repository}:1"



# REMOVE OLD CONTAINER


docker rm -f nodeapp || true



# RUN NODE.JS APPLICATION


docker run -d \
  --name nodeapp \
  --restart unless-stopped \
  -p 3000:3000 \
  "$ACCOUNT_ID.dkr.ecr.${aws_region}.amazonaws.com/${ecr_repository}:1"