# VNC-Browser 
A Lightweight, Ready-to-Use Web Browsing Environment in Docker with VNC Access

**Leave a star ⭐ if you like this project 🙂 thank you.**

[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser.svg)](https://hub.docker.com/repository/docker/mrcolorrain/vnc-browser)

## Info :information_source:
VNC-Browser is a minimal, customizable, Linux-based Docker image designed to provide a lightweight environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Debian and Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Chromium and Firefox web browsers, providing a compact solution for remotely browsing the web. Whether you're looking to browse securely or need a browsing environment within a containerized setup, VNC-Browser has you covered.

**Key Features ✨**

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux and Debian Slim, ensuring minimal resource usage.
- **Customizable**: Set VNC password, initial website URL, auto-start settings for the browser and xterm via environment variables.
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

## Available images 📦

- `mrcolorrain/vnc-browser:alpine` (with Firefox browser)
- `mrcolorrain/vnc-browser:debian` (with Chromium browser)

## Quick Start 🚀
You can run it easily using its default or by passing the appropriate environment variables.

- ### Docker CLI 🐳
  ```bash
  docker run -d -p 5900:5900 -p 6080:6080 --name vnc-browser -e VNC_PASSWORD="mypassword" mrcolorrain/vnc-browser:debian
  ```

- ### Docker Compose 🐳
  ```yaml
  version: "3.9"
  services:
    vnc-browser:
      container_name: vnc-browser
      image: mrcolorrain/vnc-browser:debian
      ports:
        - "5900:5900"
        - "6080:6080"
      environment:
        VNC_PASSWORD: "mypassword"
      restart: unless-stopped
    ```
After starting it then you can connect by:
- Using a browser, you can connect to the noVNC client on `localhost:6080` or from everywhere if properly configured using `HOSTIP:6080`
- Using a VNC Client, you can connect to `localhost:5900` or from everywhere if properly configured using `HOSTIP:5900`
## Customization 🎨
You can customize the settings of the Docker container by passing environment variables during the Docker run command. All the current settings will be printed in the container logs. Here are some examples:
- Setting the initial website URL: `STARTING_WEBSITE_URL="https://www.google.com"`
- Setting the VNC password: `VNC_PASSWORD="mypassword"`
- Setting the resolution: `VNC_RESOLUTION="1280x720"`
- Enabling/disabling auto-start for the browser: `AUTO_START_BROWSER=true` or `AUTO_START_BROWSER=false`
- Enabling/disabling auto-start for xterm: `AUTO_START_XTERM=true` or `AUTO_START_XTERM=false`

### Available Variables ⚙️
- `VNC_SCREEN` (default: `0`): Screen number for VNC.
- `VNC_DISPLAY` (default: `0`): Display number for VNC.
- `VNC_RESOLUTION` (default: `1280x720`): Resolution of the VNC display.
- `VNC_PASSWORD` (default: `money4band`): Password for VNC access.
- `VNC_PORT` (default: `5900`): Port for VNC connections.
- `NOVNC_WEBSOCKIFY_PORT` (default: `6080`): Port for noVNC web access.
- `STARTING_WEBSITE_URL` (default: `https://www.google.com`): Initial website URL opened in the browser if auto startup is true.
- `LANG` (default: `en_US.UTF-8`): Language setting for the container.
- `LC_ALL` (default: `C.UTF-8`): Locale setting for the container.
- `CUSTOMIZE` (default: `false`): Toggle for running custom scripts.
- `AUTO_START_BROWSER` (default: `true`): Automatically start the browser.
- `AUTO_START_XTERM` (default: `true`): Automatically start xterm.
- `CUSTOM_ENTRYPOINTS_DIR` (default: `/app/custom_entrypoints_scripts`): Directory for custom entry point scripts.
- `DEBIAN_FRONTEND` (default: `noninteractive`): Frontend setting for Debian-based installations.

- Example:
```sh
docker run -d -p 5900:5900 -p 6080:6080 -e STARTING_WEBSITE_URL="https://www.bing.com" -e VNC_PASSWORD="mypassword" -e VNC_RESOLUTION="1920x1080" -e AUTO_START_BROWSER=true -e AUTO_START_XTERM=true mrcolorrain/vnc-browser:alpine
```

## Adding Custom Entry Points 📜
This image allows you to add custom scripts that will be executed when the container starts, provided customization is enabled.

### Instructions for Custom Entrypoints:
- Use this Image as a Base for Your Custom Image or Mount a Volume and Add Your Scripts to the custom entrypoints Directory:
  - Option 1: Create a new image using this image as the base and copy your custom scripts in the custom entrypoints directory.
  - Option 2: Mount a volume containing your custom scripts to the /app/custom_entrypoints_scripts directory.
    - Example:`docker run -d -p 5900:5900 -p 6080:6080 -v /path/to/your/scripts:/app/custom_entrypoints_scripts -e CUSTOMIZE=true mrcolorrain/vnc-browser:debian`
- More info on custom entrypoints:
  - To customize the image place your .sh (bash) or .py (Python) scripts in the directory and Set the environment variable `CUSTOMIZE=true` to enable custom scripts execution.
    - Ensure your scripts have the necessary permissions (e.g., make scripts executable).
  - Execution Order:
    - All scripts in this directory will be executed in alphabetical order.
    - It's recommended to put a single bash entrypoint to keep the complexity low.
  - Logs:
    - The execution and output of these scripts can be reviewed in the container logs.

---

### :warning: Disclaimer
This project and its artifacts are provided "as is" and without warranty of any kind.
The author makes no warranties, express or implied, that this script is free of errors, defects, or suitable for any particular purpose.
The author shall not be retained liable for any damages suffered by any user of this script, whether direct, indirect, incidental, consequential, or special, arising from the use of or inability to use this script or its documentation, even if the author has been advised of the possibility of such damages.

## :hash: License
[GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html)
