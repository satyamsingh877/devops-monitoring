#!/bin/bash

echo "📊 Configuring Grafana Dashboard..."

# Wait for Grafana to be ready
sleep 10

# Create Prometheus datasource in Grafana
curl -X POST http://admin:admin@localhost:3000/api/datasources \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Prometheus",
    "type": "prometheus",
    "url": "http://prometheus:9090",
    "access": "proxy",
    "basicAuth": false,
    "isDefault": true
  }'

# Create Jenkins Monitoring Dashboard
cat > jenkins-dashboard.json << 'EOF'
{
  "dashboard": {
    "title": "Jenkins Jobs Monitoring",
    "panels": [
      {
        "title": "Job Build Duration",
        "type": "graph",
        "targets": [
          {
            "expr": "jenkins_job_duration_milliseconds_summary_count",
            "legendFormat": "{{job_name}}"
          }
        ]
      },
      {
        "title": "Job Success/Failure Rate",
        "type": "stat",
        "targets": [
          {
            "expr": "rate(jenkins_job_last_build_result_success[5m])",
            "legendFormat": "Success Rate"
          }
        ]
      },
      {
        "title": "Queue Size",
        "type": "gauge",
        "targets": [
          {
            "expr": "jenkins_executor_count_value"
          }
        ]
      }
    ]
  }
}
EOF

# Import dashboard
curl -X POST http://admin:admin@localhost:3000/api/dashboards/db \
  -H "Content-Type: application/json" \
  -d @jenkins-dashboard.json

echo "✅ Grafana dashboard configured!"
