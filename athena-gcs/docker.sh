#!/bin/bash

set -x

docker build -t athena-gcs-connector .
# Create ECR repository (if it doesn't exist)
aws ecr --profile drumwave-sbx create-repository --repository-name athena-gcs-connector

export AWS_ACCOUNT_ID=058264346350

# Get ECR login token
aws ecr  --profile drumwave-sbx  get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

# Tag the image
docker tag athena-gcs-connector:latest ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/athena-gcs-connector:latest

# Push the image
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/athena-gcs-connector:latest
