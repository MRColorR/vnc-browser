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
ARG DEF_CUSTOM_ENTRYPOINTS_DIR=/app/custom_entrypoints_scripts
ARG DEF_AUTO_START_BROWSER=true
ARG DEF_AUTO_START_XTERM=true
ARG DEF_DEBIAN_FRONTEND=noninteractive
ARG DEF_AUTO_START_WM=true
ARG DEF_AUTO_START_VNC=true
ARG DEF_AUTO_START_NOVNC=true
ARG DEF_BROWSER_OPTIONS=
ARG DEF_VNC_OPTIONS=
ARG DEF_WM_OPTIONS=
ARG DEF_NOVNC_OPTIONS=
ARG DEF_XTERM_OPTIONS=

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
    CUSTOM_ENTRYPOINTS_DIR=${DEF_CUSTOM_ENTRYPOINTS_DIR} \
    AUTO_START_BROWSER=${DEF_AUTO_START_BROWSER} \
    AUTO_START_XTERM=${DEF_AUTO_START_XTERM} \
    DEBIAN_FRONTEND=${DEF_DEBIAN_FRONTEND} \
    AUTO_START_XTERM=${DEF_AUTO_START_XTERM} \
    AUTO_START_WM=${DEF_AUTO_START_WM} \
    AUTO_START_VNC=${DEF_AUTO_START_VNC} \
    AUTO_START_NOVNC=${DEF_AUTO_START_NOVNC} \
    BROWSER_OPTIONS=${DEF_BROWSER_OPTIONS} \
    VNC_OPTIONS=${DEF_VNC_OPTIONS} \
    WM_OPTIONS=${DEF_WM_OPTIONS} \
    NOVNC_OPTIONS=${DEF_NOVNC_OPTIONS} \
    XTERM_OPTIONS=${DEF_XTERM_OPTIONS}

# Install necessary packages and setup noVNC
ARG PACKAGE_REFRESH
RUN set -e; \
    apt update && \
    apt full-upgrade -qqy && \
    apt install -qqy \
    tini \
    supervisor \
    bash \
    tigervnc-standalone-server \
    tigervnc-tools \
    novnc \
    websockify \
    fluxbox \
    xterm \
    nano \
    chromium && \
    apt autoremove --purge -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories for supervisor and custom entrypoints
RUN mkdir -p /etc/supervisor.d /app/conf.d ${DEF_CUSTOM_ENTRYPOINTS_DIR}
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
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/usr/local/bin/customizable_entrypoint.sh"]
