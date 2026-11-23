#!/bin/bash
set -e

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
        base_pid=$!

        # Keep Supervisor alive and stop it when a hook fails or Docker stops us.
        cleanup() {
            local status=$?
            trap - EXIT
            if kill -0 "$base_pid" 2>/dev/null; then
                kill -TERM "$base_pid" 2>/dev/null || true
            fi
            wait "$base_pid" || true
            exit "$status"
        }
        trap cleanup EXIT
        trap 'exit 143' TERM
        trap 'exit 130' INT
        echo "Base entry point is running."
        # Wait for 10 seconds
        sleep 10
    else
        echo "Base entry point script not found: /usr/local/bin/base_entrypoint.sh" >&2
        exit 1
    fi

    # Run all bash or Python scripts found inside custom entrypoints folder
    echo "Looking for custom entry point scripts..."
    if [ -d "$CUSTOM_ENTRYPOINTS_DIR" ]; then
        echo "Found custom entrypoints directory: $CUSTOM_ENTRYPOINTS_DIR"
        # list the found scripts and run them
        for script in "$CUSTOM_ENTRYPOINTS_DIR"/*; do
            if [ -f "$script" ] && [[ "$script" = *.sh || "$script" = *.py ]]; then
                echo "Running custom entry point script: $script"
                run_script "$script"
            fi
        done
    else
        echo "Custom entrypoints directory not found: $CUSTOM_ENTRYPOINTS_DIR" >&2
        exit 1
    fi

    echo "Customization completed. Waiting for Supervisor..."
    wait "$base_pid"

else
    echo "Customization is disabled. Running the base entry point in the foreground..."
    if [ -f /usr/local/bin/base_entrypoint.sh ]; then
        exec /usr/local/bin/base_entrypoint.sh
    else
        echo "Base entry point script not found: /usr/local/bin/base_entrypoint.sh" >&2
        exit 1
    fi
fi
