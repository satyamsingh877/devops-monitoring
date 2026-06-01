#!/bin/bash

# Master installation script - runs everything in order

echo "╔════════════════════════════════════════════════════╗"
echo "║   DevOps Monitoring Stack - Complete Installation  ║"
echo "╚════════════════════════════════════════════════════╝"

# Make all scripts executable
chmod +x scripts/*.sh

# Run installation steps
echo ""
echo "Step 1: Creating Docker network..."
./scripts/01-create-network.sh

echo ""
echo "Step 2: Starting all services..."
docker-compose up -d

echo ""
echo "Step 3: Waiting for services to initialize..."
sleep 20

echo ""
echo "Step 4: Configuring Jenkins..."
./scripts/03-configure-jenkins.sh

echo ""
echo "Step 5: Setting up Grafana..."
sleep 10
./scripts/05-configure-grafana.sh

echo ""
echo "Step 6: Creating job monitor..."
./scripts/04-job-monitor.sh

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║              INSTALLATION COMPLETE!                ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "📍 Access URLs:"
echo "   Jenkins:    http://localhost:8080"
echo "   Prometheus: http://localhost:9090"
echo "   Grafana:    http://localhost:3000 (admin/admin)"
echo ""
echo "📊 To collect logs from 150+ jobs:"
echo "   ./scripts/06-collect-logs.sh"
echo ""
echo "🗑️  To uninstall everything:"
echo "   ./scripts/99-uninstall.sh"
