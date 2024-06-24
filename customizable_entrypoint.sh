#!/bin/bash
set -ex

echo "Ready to start"

if [ "$CUSTOMIZE" = "true" ]; then
    echo "Customization is enabled."
    # Check if the base entry point script exists
    if [ -f /usr/local/bin/base_entrypoint.sh ]; then
        echo "Running the base entry point in the background..."
        /usr/local/bin/base_entrypoint.sh &
        echo "Base entry point is running."
        # Wait for 10 seconds
        sleep 10
    fi
    echo "Customization can be added here. If no additional services are defined then the container will exit."
    echo "Running the custom entry point..."

    # Custom logic or services can be added here
    # Example: Start a Python script
    # echo "Starting the Python script..."
    # python3 /app/your_python_script.py

    #### ADD YOUR CUSTOM CODE HERE ####

else
    echo "Customization is disabled. Running the base entry point in the foreground..."
    exec /usr/local/bin/base_entrypoint.sh
fi
