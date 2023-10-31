# Use a minimal base image
FROM alpine:edge

# Set environment variables
ENV DISPLAY=:0 \
    VNC_RESOLUTION=1024x768 \
    STARTING_WEBSITE_URL=https://www.google.com

# Install necessary packages and setup noVNC
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add --no-cache \
    xvfb \
    x11vnc \
    tini \
    supervisor \
    bash \
    fluxbox \
    firefox \
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
