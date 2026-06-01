#!/bin/bash

set -e

echo "🚀 Starting DevOps Monitoring Stack Installation..."
echo "===================================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found! Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "✅ Docker installed. Please logout and login again"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Create network
echo "🌐 Creating Docker network..."
docker network create monitor-net 2>/dev/null || echo "Network exists"

# Start services
echo "🐳 Starting containers..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Get Jenkins initial password
echo "🔐 Jenkins Initial Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "Check Jenkins logs"

echo ""
echo "✅ Installation Complete!"
echo "===================================================="
echo "📊 Access URLs:"
echo "Jenkins:    http://localhost:8080"
echo "Prometheus: http://localhost:9090"
echo "Grafana:    http://localhost:3000 (admin/admin)"
echo "===================================================="
echo "💡 Next Steps:"
echo "1. Configure Jenkins jobs"
echo "2. Install Prometheus plugin in Jenkins"
echo "3. Check Jenkins metrics at http://localhost:8080/prometheus"
