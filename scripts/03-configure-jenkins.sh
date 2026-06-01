#!/bin/bash

echo "🔧 Configuring Jenkins for Monitoring..."

# Install Prometheus plugin
echo "Installing Prometheus plugin..."
JENKINS_CLI="java -jar jenkins-cli.jar"

# Plugin installation script
cat > install-plugins.groovy << 'EOF'
import jenkins.model.*
import java.util.logging.Logger

def logger = Logger.getLogger("")
def instance = Jenkins.getInstance()
def pluginManager = instance.getPluginManager()
def updateCenter = instance.getUpdateCenter()

// List of plugins to install
def plugins = [
    "prometheus",
    "metrics",
    "job-import-plugin"
]

plugins.each { plugin ->
    def pluginManager = instance.getPluginManager()
    def pluginWrapper = pluginManager.getPlugin(plugin)
    if (pluginWrapper == null) {
        logger.info("Installing ${plugin}...")
        def pluginUrl = updateCenter.getPlugin(plugin)?.getLatest()?.getUrl()
        if (pluginUrl) {
            def installFuture = pluginManager.install(plugin, false)
            installFuture.get()
        }
    }
}

instance.save()
logger.info("Plugins installation completed!")
EOF

# Copy to Jenkins
docker cp install-plugins.groovy jenkins:/tmp/
docker exec jenkins groovy /tmp/install-plugins.groovy

echo "✅ Jenkins configured for Prometheus metrics"
