#!/bin/bash

echo "⚠️  WARNING: This will remove all monitoring containers and data!"
read -p "Are you sure? Type 'yes' to continue: " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Uninstall cancelled"
    exit 1
fi

echo "🗑️  Stopping and removing containers..."
docker-compose down -v

echo "🗑️  Removing Docker network..."
docker network rm monitor-net 2>/dev/null

echo "🗑️  Removing data directories..."
rm -rf jenkins_home prometheus_data grafana_data

echo "🗑️  Removing logs..."
rm -rf jenkins_logs

echo "✅ Complete uninstall successful!"
echo "📝 Note: Docker images still available. Remove manually if needed:"
echo "   docker rmi jenkins/jenkins:lts prom/prometheus grafana/grafana"
