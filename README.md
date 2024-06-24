# VNC-Browser 
A Lightweight Web Browsing Environment in Docker with VNC Access

**Leave a star ⭐ if you like this project 🙂 thank you.**

[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser.svg)](https://hub.docker.com/repository/docker/mrcolorrain/vnc-browser)

## Info :information_source:
VNC-Browser is a minimal, customizable, Linux-based Docker image designed to provide a lightweight environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Debian and Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Choromium and Firefox web browser, providing a compact solution for remotely browsing the web. Whether you're looking to browse securely or need a browsing environment within a containerized setup, VNC-Browser has you covered.

**Key Features ✨**

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux and debian-slim, ensuring minimal resource usage.
- **Customizable**: Set VNC password, initial website URL, auto-start settings for browser and xterm via environment variables.
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

## Getting Started 🚥

### Prerequisites

- Docker installed on your system.
- Basic knowledge of Docker and containerization.

### Pull & Run :arrow_forward::
- Pull & Run the Image: `docker run -d -p 5900:5900 -p 6080:6080 mrcolorrain/vnc-browser`
  - Using a browser, you can connect to noVNC client on `localhost:6080` or from everywhere if properly configured using `HOSTIP:6080`
  - Using a VNC Client you can connect to  `localhost:5900` or from everywhere if properly configured using `HOSTIP:5900`

## Customization 🎨
You can customize the settings of the Docker container by passing environment variables during the Docker run command. Here are some examples:
- Setting the initial website URL: `STARTING_WEBSITE_URL="https://www.google.com"`
- Setting the VNC password: `VNC_PASSWORD="mypassword"`
- Setting the resolution: `VNC_RESOLUTION="1280x720"`
- Enabling/disabling auto-start for the browser: `AUTO_START_BROWSER=true` or `AUTO_START_BROWSER=false`
- Enabling/disabling auto-start for xterm: `AUTO_START_XTERM=true` or `AUTO_START_XTERM=false`

- Example:
```sh
docker run -d -p 5900:5900 -p 6080:6080 -e STARTING_WEBSITE_URL="https://www.bing.com" -e VNC_PASSWORD="mypassword" -e VNC_RESOLUTION="1920x1080" -e AUTO_START_BROWSER=true -e AUTO_START_XTERM=true mrcolorrain/vnc-browser
```


---

### :warning: Disclaimer
This project and its artifacts are provided "as is" and without warranty of any kind.
The author makes no warranties, express or implied, that this script is free of errors, defects, or suitable for any particular purpose.  
The author shall not be retained liable for any damages suffered by any user of this script, whether direct, indirect, incidental, consequential, or special, arising from the use of or inability to use this script or its documentation, even if the author has been advised of the possibility of such damages.  

## :hash: License
[GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html)
