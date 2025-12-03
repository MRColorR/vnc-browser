FROM debian:stable-slim

# Build arguments
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
ARG DEF_AUTO_START_X11VNC=true
ARG DEF_AUTO_START_XVFB=true
ARG DEF_AUTO_START_NOVNC=true

# Edge browser options
ARG DEF_BROWSER_OPTIONS=--no-sandbox\ --disable-dev-shm-usage

ARG DEF_X11VNC_OPTIONS=
ARG DEF_XVFB_OPTIONS=
ARG DEF_WM_OPTIONS=
ARG DEF_NOVNC_OPTIONS=
ARG DEF_XTERM_OPTIONS=

# Environment vars
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
    AUTO_START_WM=${DEF_AUTO_START_WM} \
    AUTO_START_X11VNC=${DEF_AUTO_START_X11VNC} \
    AUTO_START_XVFB=${DEF_AUTO_START_XVFB} \
    AUTO_START_NOVNC=${DEF_AUTO_START_NOVNC} \
    BROWSER_OPTIONS="${DEF_BROWSER_OPTIONS}" \
    X11VNC_OPTIONS=${DEF_X11VNC_OPTIONS} \
    XVFB_OPTIONS=${DEF_XVFB_OPTIONS} \
    WM_OPTIONS=${DEF_WM_OPTIONS} \
    NOVNC_OPTIONS=${DEF_NOVNC_OPTIONS} \
    XTERM_OPTIONS=${DEF_XTERM_OPTIONS}

# Install Edge + Desktop stack
RUN set -e; \
    apt update && \
    apt install -qqy wget gnupg && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- \
        | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" \
        > /etc/apt/sources.list.d/microsoft-edge.list && \
    apt update && \
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
        microsoft-edge-stable && \
    apt autoremove --purge -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Directories
RUN mkdir -p /etc/supervisor.d /app/conf.d ${DEF_CUSTOM_ENTRYPOINTS_DIR} /shell /var/log/supervisor

# Copy configs
COPY supervisord.conf /etc/supervisor.d/supervisord.conf
COPY conf.d/ /app/conf.d/
COPY conf.d/browsers/edge.conf /app/conf.d/

# New entrypoint system
COPY shell/master.sh /shell/master.sh
COPY shell/user.sh /shell/user.sh

RUN chmod +x /shell/master.sh /shell/user.sh

# Expose required ports
EXPOSE ${VNC_PORT} ${NOVNC_WEBSOCKIFY_PORT}

# Entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/shell/user.sh"]
CMD []
