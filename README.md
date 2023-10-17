# VNC-Browser 
A Lightweight Web Browsing Environment in Docker with VNC Access

**Leave a star ⭐ if you like this project 🙂 thank you.**

[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser.svg)](https://hub.docker.com/repository/docker/mrcolorrain/vnc-browser)

## Info :information_source:
VNC-Browser is a minimal, Alpine Linux-based Docker image designed to provide a lightweight and secure environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Firefox web browser, providing a compact solution for remotely browsing the web. Whether you're looking to browse securely or need a browsing environment within a containerized setup, VNC-Browser has you covered.

**Key Features ✨**

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux, ensuring minimal resource usage.
- **Customizable**: Set VNC password and the initial website URL via environment variables.
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

## Getting Started 🚥

### Prerequisites

- Docker installed on your system.
- Basic knowledge of Docker and containerization.

### Pull & Run :arrow_forward::
- Pull & Run the Image: `docker run -d -p 5901:5901 -p 6901:6901 mrcolorrain/vnc-browser`
  - Using abrowser you can connect to noVNC client on `localhost:6901` or from everywhere if properly configured using `HOSTIP:5901`
  - Using a VNC Client you can connect to  `localhost:5901` or from everywhere if properly configured using `HOSTIP:5901`

## Customization 🎨
You can customize the settings of the Docker container by passing environment variables during the Docker run command. Here are some examples::
- setting the initial website URL: `STARTING_WEBSITE_URL="https://www.google.com" ` 
- setting the VNC password ` VNC_PASSWORD="mypassword"`
- setting the resolution: ` VNC_RESOLUTION="1280x720" ` 

- Example:
`docker run -d -p 5901:5901 -p 6901:6901 -e STARTING_WEBSITE_URL="https://www.bing.com" -e VNC_PASSWORD="mypassword" -e VNC_RESOLUTION="1920x1080" mrcolorrain/vnc-browser`

---

### :warning: Disclaimer
This project and its artifacts are provided "as is" and without warranty of any kind.
The author makes no warranties, express or implied, that this script is free of errors, defects, or suitable for any particular purpose.  
The author shall not be retained liable for any damages suffered by any user of this script, whether direct, indirect, incidental, consequential, or special, arising from the use of or inability to use this script or its documentation, even if the author has been advised of the possibility of such damages.  

## :hash: License
[GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html)
