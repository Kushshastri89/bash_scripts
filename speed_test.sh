#!/bin/bash

# File: speedtest_logger.sh

# Set log file
LOG_FILE="$HOME/speedtest_log.csv"

# Create log file with headers if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    echo "Date,Time,Download (Mbps),Upload (Mbps),Ping (ms)" > "$LOG_FILE"
fi

# Run speed test
RESULT=$(speedtest-cli --simple)
PING=$(echo "$RESULT" | grep 'Ping' | awk '{print $2}')
DOWNLOAD=$(echo "$RESULT" | grep 'Download' | awk '{print $2}')
UPLOAD=$(echo "$RESULT" | grep 'Upload' | awk '{print $2}')
DATE=$(date '+%Y-%m-%d')
TIME=$(date '+%H:%M:%S')

# Output results
echo "Date: $DATE"
echo "Time: $TIME"
echo "Ping: $PING ms"
echo "Download: $DOWNLOAD Mbps"
echo "Upload: $UPLOAD Mbps"

# Save to log
echo "$DATE,$TIME,$DOWNLOAD,$UPLOAD,$PING" >> "$LOG_FILE"
