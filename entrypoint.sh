#!/usr/bin/env bash
set -ex

# Store the password
if [ "$VNC_PASSWORD" ]; then
    sed -i "s/^\(command.*x11vnc.*\)$/\1 -passwd '$VNC_PASSWORD'/" /app/conf.d/x11vnc.conf
fi

# Print current VNC info
echo "Current VNC info:"
echo "-----------------"
echo "VNC Screen: ${VNC_SCREEN}"
echo "VNC Display: ${VNC_DISPLAY}"
echo "VNC resolution: ${VNC_RESOLUTION}"
echo "VNC password: ${VNC_PASSWORD}"
echo "VNC Port: ${VNC_PORT}"
echo "NOVNC Websockify Port: ${NOVNC_WEBSOCKIFY_PORT}"

# Print other container's info
echo "-----------------"
echo "Other Info:"
echo "-----------------"
echo "Debian Frontend: ${DEBIAN_FRONTEND}"
echo "Lang: ${LANG}"
echo "LC All: ${LC_ALL}"
echo "Homepage website URL: ${STARTING_WEBSITE_URL}"
echo "-----------------"

# Set VNC resolution
export DISPLAY=:${VNC_DISPLAY}.${VNC_SCREEN}
Xvfb :${VNC_DISPLAY} -screen ${VNC_SCREEN} ${VNC_RESOLUTION}x24 &

# Start Supervisor
exec supervisord -c /etc/supervisor.d/supervisord.conf
