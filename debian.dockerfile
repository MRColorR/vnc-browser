# Use a minimal base image
FROM debian:stable-slim

# Build arguments to set environment variables at build time
ARG DEF_VNC_DISPLAY=99
ARG DEF_VNC_PASSWORD=money4band
ARG DEF_VNC_RESOLUTION=1280x720
ARG DEF_STARTING_WEBSITE_URL=https://www.google.com
ARG DEF_RUN_XTERM=true

# Set environment variables
# Set environment variables with default values
ENV VNC_DISPLAY=${DEF_VNC_DISPLAY} \
    VNC_PASSWORD=${DEF_VNC_PASSWORD} \
    VNC_RESOLUTION=${DEF_VNC_RESOLUTION} \
    STARTING_WEBSITE_URL=${DEF_STARTING_WEBSITE_URL} \
    RUN_XTERM=${DEF_RUN_XTERM}

# Install necessary packages and setup noVNC
RUN set -ex; \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add --no-cache \
    tini \
    supervisor \
    xvfb \
    x11vnc \
    bash \
    fluxbox \
    chromium \
    novnc \
    websockify && \
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html

# Copy configuration files
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Expose VNC and noVNC ports
EXPOSE 5901 6901

# Set tini as the entrypoint and the custom script as the command
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
