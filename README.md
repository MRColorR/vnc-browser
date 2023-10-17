# vnc-browser

# VNC-Browser 
# A Lightweight Web Browsing Environment in Docker with VNC Access

Run and manage a lightweight web browsing environment in a Docker container with VNC support for easy GUI access.

**Leave a star ⭐ if you like this project 🙂 thank you.**

[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser.svg)](https://hub.docker.com/repository/docker/mrcolorrain/vnc-browser)

## :information_source: Info
VNC-Browser is a minimal, Alpine Linux-based Docker image designed to provide a lightweight and secure environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Firefox web browser, providing a compact solution for remotely browsing the web. Whether you're looking to browse securely or need a browsing environment within a containerized setup, VNC-Browser has you covered.

## Features

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux, ensuring minimal resource usage.
- **Customizable**: Set VNC password and the initial website URL via environment variables.
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

## :arrow_forward: Getting Started

### Prerequisites

- Docker installed on your system.
- Basic knowledge of Docker and containerization.

### Pull & Run:
- Pull & Run the Image: 
```bash
docker run -p 5901:5901 -p 6901:6901 -e VNC_PASSWORD="yourpassword" -e STARTING_WEBSITE_URL="https://example.com" mrcolorrain/vnc-browser:latest
