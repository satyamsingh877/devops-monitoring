#!/bin/bash

# Create Jenkins pipeline job for monitoring
cat > Jenkinsfile << 'EOF'
pipeline {
    agent any
    
    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building application...'
                // Your build steps here
                sh 'echo "Build completed at $(date)"'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                // Simulate test execution
                sh 'sleep 5'
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                // Deployment steps
                sh 'echo "Deployed successfully"'
            }
        }
    }
    
    post {
        always {
            // Record metrics
            script {
                def duration = currentBuild.duration
                def result = currentBuild.currentResult
                
                // Send metrics to Prometheus via HTTP endpoint
                sh """
                    curl -X POST http://prometheus:9090/-/reload \
                    --data-binary @/dev/null 2>/dev/null || true
                """
                
                echo "Job Duration: ${duration}ms"
                echo "Job Result: ${result}"
            }
        }
        success {
            echo '🎉 Job succeeded!'
        }
        failure {
            echo '❌ Job failed!'
        }
    }
}
EOF

echo "✅ Jenkinsfile created for monitoring"
