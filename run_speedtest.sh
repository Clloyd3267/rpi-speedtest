#!/bin/bash
# -----------------------------------------------------------------------------
# FILE: run_speedtest.sh
# Created: 2023-10-05
# Author: clloyd
# Description: This script runs a speedtest, parses the results, and sends 
#              the data to InfluxDB.
# -----------------------------------------------------------------------------

# Configs
INFLUX_BUCKET="speedtest"
INFLUX_ORG="clloyd"
INFLUX_TOKEN="fcb7TZdUQX4Z-ndjoDnxinv90AOK1iN2AP-g5BsZT95Mq89Xq6xXqOVdIc8_ZZrFb0VVvN_Xj97LJPxN90iusA=="
INFLUX_URL="http://localhost:8086"
LOG_FILE="$(dirname "$0")/speedtest.log"

# Run speedtest and parse JSON
DATA=$(/usr/bin/speedtest --accept-license -f json)

# Log JSON data to file
echo "$DATA" >> "$LOG_FILE"

# Validate speedtest ran successfully
if [[ $? -ne 0 || -z "$DATA" ]]; then
  echo "ERROR: Speedtest failed."
  exit 1
fi

# Extract values using jq
DOWNLOAD=$(echo "$DATA" | jq '.download.bandwidth')
UPLOAD=$(echo "$DATA" | jq '.upload.bandwidth')
PING=$(echo "$DATA" | jq '.ping.latency')

# Validate extracted values
if [[ -z "$DOWNLOAD" || -z "$UPLOAD" || -z "$PING" ]]; then
  echo "ERROR: Failed to extract metrics."
  exit 1
fi

# Convert bandwidth from bits/sec to Mbit/sec
DOWNLOAD_MB=$(echo "scale=2; $DOWNLOAD * 8 / 1000000" | bc)
UPLOAD_MB=$(echo "scale=2; $UPLOAD * 8 / 1000000" | bc)

# Compose line protocol for InfluxDB
TIMESTAMP_EPOCH=$(date +%s)
LINE="internet_speed download=${DOWNLOAD_MB},upload=${UPLOAD_MB},ping=${PING} ${TIMESTAMP_EPOCH}"

# Send to InfluxDB
echo "$LINE" | influx write \
  --bucket "$INFLUX_BUCKET" \
  --org "$INFLUX_ORG" \
  --token "$INFLUX_TOKEN" \
  --precision s \
  --host "$INFLUX_URL"

# Check if the influx write command was successful
if [[ $? -ne 0 ]]; then
  echo "ERROR: Failed to write data to InfluxDB."
  exit 1
fi

echo "Speedtest data uploaded to Influxdb: $LINE"