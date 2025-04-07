#!/bin/bash

# DevDash Monitor Script
# This script monitors file changes in a specific directory and triggers actions.

monitor_changes() {
    local watch_dir="/path/to/watch"  # Replace with the directory you want to monitor
    echo "Monitoring directory: ${watch_dir}"
    
    inotifywait -m -r -e modify,create,delete "$watch_dir" |
    while read -r path action file; do
        echo "File '$file' in directory '$path' was ${action}."
        # Add commands here to trigger build/test actions when a change is detected.
    done
}

monitor_changes
