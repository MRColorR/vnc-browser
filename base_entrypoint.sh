#!/usr/bin/env bash
set -e

# Add password to vnc options
if [ -n "${VNC_PASSWORD}" ]; then
    mkdir -p ~/.vnc
    (umask 077; printf '%s\n' "${VNC_PASSWORD}" | vncpasswd -f > ~/.vnc/passwd)
    chmod 600 ~/.vnc/passwd
    export VNC_OPTIONS="${VNC_OPTIONS} -SecurityTypes VncAuth -PasswordFile /root/.vnc/passwd"
else
    export VNC_OPTIONS="${VNC_OPTIONS} -SecurityTypes None"
fi

if [ "${THEME-light}" = "dark" ]; then
    theme_dir=/run/vnc-browser-theme
    # Fluxbox copies its default config over the selected rc on first launch.
    mkdir -p "$theme_dir" "$HOME/.fluxbox"
    sed 's/^background\.color:.*/background.color: #333333/' \
        /usr/share/fluxbox/styles/BlueNight > "$theme_dir/BlueNight"
    printf 'session.styleFile: %s/BlueNight\n' "$theme_dir" > "$theme_dir/fluxbox.init"
    export GTK_THEME="${GTK_THEME:-Adwaita:dark}"
    export WM_OPTIONS="-rc $theme_dir/fluxbox.init ${WM_OPTIONS}"
    export XTERM_OPTIONS="-bg #333333 -fg #eeeeee ${XTERM_OPTIONS}"
fi

# Print current VNC info
echo "Current VNC info:"
echo "-----------------"
echo "VNC Screen: ${VNC_SCREEN}"
echo "VNC Display: ${VNC_DISPLAY}"
echo "VNC resolution: ${VNC_RESOLUTION}"
if [ -n "${VNC_PASSWORD}" ]; then
    echo "VNC password: configured"
else
    echo "VNC password: not configured (authentication disabled)"
fi
echo "VNC Port: ${VNC_PORT}"
echo "NOVNC Websockify Port: ${NOVNC_WEBSOCKIFY_PORT}"

# Print other container's info
echo "-----------------"
echo "Other Info:"
echo "-----------------"
echo "Lang: ${LANG}"
echo "LC All: ${LC_ALL}"
echo "Customize active: ${CUSTOMIZE}"
echo "Custom entrypoints dir: ${CUSTOM_ENTRYPOINTS_DIR}"
echo "Autostart browser: ${AUTO_START_BROWSER}"
echo "Homepage website URL: ${STARTING_WEBSITE_URL}"
echo "Autostart xterm: ${AUTO_START_XTERM}"
echo "-----------------"

# Start Supervisor
exec supervisord -c /etc/supervisor.d/supervisord.conf
