#!/bin/bash
# Create Docker network for monitoring
docker network create monitor-net 2>/dev/null || echo "Network already exists"
echo "✅ Docker network 'monitor-net' created"
