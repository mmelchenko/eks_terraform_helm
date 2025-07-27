$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$tfDir = Join-Path $scriptDir "..\terraform"

Write-Host "Switching to Terraform directory: $tfDir"
Set-Location -Path $tfDir

Write-Host "Initializing Terraform..."
terraform init

Write-Host "Validating Terraform..."
terraform validate

Write-Host "Planning Terraform..."
terraform plan -out="tfplan"

Write-Host "Applying Terraform plan..."
terraform apply -auto-approve "tfplan"

Write-Host "Configuring kubectl for EKS..."

$region = "eu-north-1"
$clusterName = terraform output -raw cluster_name

aws eks update-kubeconfig --region $region --name $clusterName

Write-Host "Done! kubectl is configured for EKS cluster '$clusterName'"
