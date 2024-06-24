# Use a minimal base image
FROM debian:stable-slim

# Build arguments to set environment variables at build time
ARG DEF_VNC_SCREEN=0
ARG DEF_VNC_DISPLAY=0
ARG DEF_VNC_RESOLUTION=1280x720
ARG DEF_VNC_PASSWORD=money4band
ARG DEF_VNC_PORT=5900
ARG DEF_NOVNC_WEBSOCKIFY_PORT=6080
ARG DEF_STARTING_WEBSITE_URL=https://www.google.com
ARG DEF_LANG=en_US.UTF-8
ARG DEF_LC_ALL=C.UTF-8
ARG DEF_CUSTOMIZE=false
ARG DEF_AUTO_START_BROWSER=true
ARG DEF_AUTO_START_XTERM=true
ARG DEF_DEBIAN_FRONTEND=noninteractive

# Set environment variables with default values
ENV DISPLAY=:${DEF_VNC_DISPLAY}.${DEF_VNC_SCREEN} \
    VNC_SCREEN=${DEF_VNC_SCREEN} \
    VNC_DISPLAY=${DEF_VNC_DISPLAY} \
    VNC_RESOLUTION=${DEF_VNC_RESOLUTION} \
    VNC_PASSWORD=${DEF_VNC_PASSWORD} \
    VNC_PORT=${DEF_VNC_PORT} \
    NOVNC_WEBSOCKIFY_PORT=${DEF_NOVNC_WEBSOCKIFY_PORT} \
    STARTING_WEBSITE_URL=${DEF_STARTING_WEBSITE_URL} \
    LANG=${DEF_LANG} \
    LC_ALL=${DEF_LC_ALL} \
    CUSTOMIZE=${DEF_CUSTOMIZE} \
    AUTO_START_BROWSER=${DEF_AUTO_START_BROWSER} \
    AUTO_START_XTERM=${DEF_AUTO_START_XTERM} \
    DEBIAN_FRONTEND=${DEF_DEBIAN_FRONTEND}

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
    websockify \
    fluxbox \
    xterm \
    nano \
    chromium && \
    apt autoremove --purge -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories for supervisor
RUN mkdir -p /etc/supervisor.d /app/conf.d
RUN mkdir -p /var/log/supervisor

# Copy configuration files
COPY supervisord.conf /etc/supervisor.d/supervisord.conf
COPY conf.d/ /app/conf.d/
COPY base_entrypoint.sh customizable_entrypoint.sh /usr/local/bin/
COPY browser_conf/chromium.conf /app/conf.d/
# Make the entrypoint scripts executable
RUN chmod +x /usr/local/bin/base_entrypoint.sh /usr/local/bin/customizable_entrypoint.sh

# Expose the standard VNC and noVNC ports
EXPOSE ${VNC_PORT} ${NOVNC_WEBSOCKIFY_PORT}

# Set tini as the entrypoint and the custom script as the command
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/customizable_entrypoint.sh"]
