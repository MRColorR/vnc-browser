# Use a minimal base image
FROM debian:stable-slim

# Build arguments to set environment variables at build time
ARG DEF_VNC_SCREEN=0
ARG DEF_VNC_DISPLAY=99
ARG DEF_VNC_RESOLUTION=1280x720
ARG DEF_VNC_PASSWORD=money4band
ARG DEF_STARTING_WEBSITE_URL=https://www.google.com
ARG DEF_DEBIAN_FRONTEND=noninteractive
ARG DEF_LANG=en_US.UTF-8
ARG DEF_LC_ALL=C.UTF-8
ARG DEF_VNC_PORT=5900
ARG DEF_WEBSOCKIFY_PORT=6080

# Set environment variables with default values
ENV VNC_SCREEN=${DEF_VNC_SCREEN} \
    VNC_DISPLAY=${DEF_VNC_DISPLAY} \
    VNC_RESOLUTION=${DEF_VNC_RESOLUTION} \
    VNC_PASSWORD=${DEF_VNC_PASSWORD} \
    VNC_PORT=${DEF_VNC_PORT} \
    WEBSOCKIFY_PORT=${DEF_WEBSOCKIFY_PORT} \
    STARTING_WEBSITE_URL=${DEF_STARTING_WEBSITE_URL} \
    DEBIAN_FRONTEND=${DEF_DEBIAN_FRONTEND} \
    LANG=${DEF_LANG} \
    LC_ALL=${DEF_LC_ALL} 

# Install necessary packages and setup noVNC
RUN set -ex; \
    apt update && \
    apt full-upgrade -qqy && \
    apt install -qqy \
    tini \
    supervisor \
    bash \
    xvfb \
    x11vnc \
    novnc \
    fluxbox \
    websockify \
    chromium && \
    ln -s /usr/share/novnc/vnc_lite.html /usr/share/novnc/index.html && \
    apt autoremove --purge -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories for supervisor
RUN mkdir -p /etc/supervisor.d /app/conf.d

# Copy configuration files
COPY supervisord.conf /etc/supervisor.d/supervisord.conf
COPY conf.d/ /app/conf.d/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the standard VNC and noVNC ports
EXPOSE ${VNC_PORT} ${NOVNC_WEBSOCKIFY_PORT}

# Set tini as the entrypoint and the custom script as the command
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/entrypoint.sh"]
