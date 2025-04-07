#!/bin/bash

# DevDash Dashboard Script
# This script displays real-time system monitoring information.

display_stats() {
    clear
    echo "=== System Dashboard ==="
    echo "Uptime: $(uptime -p)"
    
    # Calculate CPU usage by subtracting the idle CPU percentage from 100%
    idle=$(top -bn1 | grep "Cpu(s)" | sed -n 's/.*, *\([0-9.]*\)%* id.*/\1/p')
    cpu_usage=$(echo "100 - $idle" | bc)
    echo "CPU Usage: ${cpu_usage}%"
    
    # Calculate memory usage percentage
    mem_usage=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100.0}')
    echo "Memory Usage: ${mem_usage}%"
    
    echo "Network Status:"
    # Display IP addresses from network interfaces (adjust as needed for your system)
    ifconfig | grep 'inet ' | awk '{print $2}'
    echo "========================"
}

# Continuously update the dashboard every 5 seconds
while true; do
    display_stats
    sleep 5
done
