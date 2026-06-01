#!/bin/bash

LOG_DIR="./jenkins_logs"
mkdir -p $LOG_DIR

echo "📝 Collecting logs from 150+ Jenkins jobs..."

# Get all Jenkins jobs
JOBS=$(docker exec jenkins groovy -e 'Jenkins.instance.getAllItems(hudson.model.Job.class)*.fullName')

# Function to collect logs for each job
collect_job_logs() {
    local job_name=$1
    local log_file="$LOG_DIR/${job_name//\//_}.log"
    
    echo "Processing: $job_name"
    
    # Get last 100 builds
    builds=$(docker exec jenkins groovy -e "
        def job = Jenkins.instance.getItemByFullName('$job_name')
        if(job) {
            job.builds.take(100).each { build ->
                println(build.number)
            }
        }
    ")
    
    # Collect logs
    for build_num in $builds; do
        docker exec jenkins groovy -e "
            def job = Jenkins.instance.getItemByFullName('$job_name')
            def build = job.getBuildByNumber($build_num)
            if(build) {
                def log = build.getLog(1000)
                println('=== Build #$build_num - ' + build.timestampString + ' ===')
                println(log)
                println('=== END ===')
            }
        " >> "$log_file" 2>/dev/null
    done
    
    echo "✅ Logs saved to: $log_file"
}

# Process each job
for job in $JOBS; do
    collect_job_logs "$job"
done

# Create summary report
cat > $LOG_DIR/summary.txt << EOF
Jenkins Logs Collection Summary
================================
Date: $(date)
Total Jobs Processed: $(echo "$JOBS" | wc -l)
Log Directory: $LOG_DIR

Job List:
$JOBS
EOF

echo "🎯 Log collection complete!"
echo "📁 Logs saved in: $LOG_DIR"
