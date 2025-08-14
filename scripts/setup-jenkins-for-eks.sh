#!/bin/bash

# Executar no Jenkins EC2 para configurar kubectl
echo "🔧 Configurando Jenkins para EKS..."

# Instalar kubectl
curl -LO "https://dl.k8s.io/release/v1.28.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Instalar eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Dar permissões ao usuário jenkins
sudo usermod -a -G docker jenkins

echo "✅ Jenkins configurado para EKS!"
echo "⚠️  Configure as credenciais no Jenkins:"
echo "   - ECR_REPOSITORY"
echo "   - AWS_ACCOUNT_ID" 
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"