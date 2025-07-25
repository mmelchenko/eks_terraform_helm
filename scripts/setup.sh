#!/bin/bash

set -e

echo "Initializing Terraform..."
cd terraform
terraform init

echo "Planning Terraform..."
terraform plan

echo "Applying Terraform..."
terraform apply -auto-approve

CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw region)

echo "Updating kubeconfig..."
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"

echo "Cluster setup complete."

cd ..
