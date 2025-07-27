$ErrorActionPreference = "Stop"

function Install-Helm {
    Write-Host "Checking Helm installation..."
    if (-not (Get-Command helm -ErrorAction SilentlyContinue)) {
        Write-Host "Helm not found. Downloading and installing..."
        $helmVersion = "v3.18.4"
        $helmUrl = "https://get.helm.sh/helm-$helmVersion-windows-amd64.zip"
        $zipPath = "$env:TEMP\helm.zip"
        $extractPath = "$env:TEMP\helm-extract"

        Invoke-WebRequest -Uri $helmUrl -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        $helmExe = Join-Path $extractPath "windows-amd64\helm.exe"
        $targetPath = "$env:ProgramFiles\helm"
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath | Out-Null
        }
        Copy-Item $helmExe "$targetPath\helm.exe" -Force

        $env:PATH += ";$targetPath"
        Write-Host "Helm installed at $targetPath"
    } else {
        Write-Host "Helm already installed."
    }
}

function Deploy-App {
    Write-Host "Starting Helm deployment..."

    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update

    $releaseName = "my-nginx"
    $namespace = "default"

    if (helm status $releaseName -n $namespace -ErrorAction SilentlyContinue) {
        Write-Host "Helm release '$releaseName' already exists. Upgrading..."
        helm upgrade $releaseName bitnami/nginx --namespace $namespace
    } else {
        Write-Host "Installing Helm chart..."
        helm install $releaseName bitnami/nginx --namespace $namespace
    }

    Write-Host "Waiting for LoadBalancer IP..."
    Start-Sleep -Seconds 10

    $svc = kubectl get svc $releaseName -n $namespace -o json
    $ip = ($svc | ConvertFrom-Json).status.loadBalancer.ingress[0].hostname

    if ($ip) {
        Write-Host "App is acctessible at: htp://$ip"
    } else {
        Write-Host "LoadBalancer IP not ready yet. Try again in a minute:"
        Write-Host "kubectl get svc $releaseName -n $namespace"
    }
}

Install-Helm
Deploy-App
