#!/bin/bash
set -ex

echo "Ready to start"

# Function to run scripts
run_script() {
    local script=$1
    case "$script" in
        *.sh)
            if [ -x "$script" ]; then
                "$script"
            else
                bash "$script"
            fi
            ;;
        *.py)
            if [ -x "$script" ]; then
                "$script"
            else
                python3 "$script"
            fi
            ;;
        *)
            echo "Unknown file type: $script" >&2
            ;;
    esac
}

if [ "$CUSTOMIZE" = "true" ]; then
    echo "Customization is enabled."
    # Check if the base entry point script exists
    if [ -f /usr/local/bin/base_entrypoint.sh ]; then
        echo "Running the base entry point in the background..."
        /usr/local/bin/base_entrypoint.sh &
        echo "Base entry point is running."
        # Wait for 10 seconds
        sleep 10
    else
        echo "Base entry point script not found: /usr/local/bin/base_entrypoint.sh" >&2
        exit 1
    fi

    # Run all bash or Python scripts found inside custom entrypoints folder
    if [ -d "$CUSTOM_ENTRYPOINTS_DIR" ]; then
        for script in "$CUSTOM_ENTRYPOINTS_DIR"/*.{sh,py}; do
            if [ -f "$script" ]; then
                echo "Running custom entry point script: $script"
                run_script "$script"
            fi
        done
    else
        echo "Custom entrypoints directory not found: $CUSTOM_ENTRYPOINTS_DIR" >&2
        exit 1
    fi

    echo "Customization completed. If no additional services are defined then the container will exit."

else
    echo "Customization is disabled. Running the base entry point in the foreground..."
    if [ -f /usr/local/bin/base_entrypoint.sh ]; then
        exec /usr/local/bin/base_entrypoint.sh
    else
        echo "Base entry point script not found: /usr/local/bin/base_entrypoint.sh" >&2
        exit 1
    fi
fi
