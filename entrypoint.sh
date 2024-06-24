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
echo "VNC Display is: ${VNC_DISPLAY}"
echo "VNC resolution is: ${VNC_RESOLUTION}"
echo "VNC password is: ${VNC_PASSWORD}"
echo "VNC Port: ${VNC_PORT}"
echo "NOVNC Websockify Port: ${NOVNC_WEBSOCKIFY_PORT}"

# Print other container's info: like     DEBIAN_FRONTEND=${DEF_DEBIAN_FRONTEND} \    LANG=${DEF_LANG} \    LANGUAGE=${DEF_LANGUAGE} \    LC_ALL=${DEF_LC_ALL}
echo "-----------------"
echo "Other Info:"
echo "-----------------"
echo "Debian Frontend: ${DEF_DEBIAN_FRONTEND}"
echo "Lang: ${DEF_LANG}"
echo "LC All: ${DEF_LC_ALL}"
echo "Homepage website URL: ${STARTING_WEBSITE_URL}"
echo "-----------------"

# Start Supervisor
echo "Starting Supervisor"
exec supervisord -c /etc/supervisord.conf