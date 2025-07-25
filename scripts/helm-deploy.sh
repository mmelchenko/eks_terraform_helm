#!/bin/bash

set -e

echo "Installing Helm..."
curl -sSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Adding Bitnami repo..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

echo "Installing nginx chart..."
helm install my-nginx bitnami/nginx

echo "Waiting for LoadBalancer IP..."
sleep 30

kubectl get svc my-nginx -o wide
