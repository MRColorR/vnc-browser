# VNC-Browser

<!-- Project README scaffold: https://github.com/MRColorR/project-template -->

**Run a browser in Docker and connect to it over VNC.**

[**🚀 Run the Docker image**](#getting-started) · [📚 Documentation](#documentation) · [🫶 Support](#support)

**Leave a star ⭐ if you like this project 🙂 Thank you!**

## Overview

A Lightweight, Ready-to-Use Web Browsing Environment in Docker with VNC Access


[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser?style=flat-square&link=https://hub.docker.com/r/mrcolorrain/vnc-browser)](https://hub.docker.com/r/mrcolorrain/vnc-browser)
[![Docker Stars](https://img.shields.io/docker/stars/mrcolorrain/vnc-browser?style=flat-square&link=https://hub.docker.com/r/mrcolorrain/vnc-browser)](https://hub.docker.com/r/mrcolorrain/vnc-browser)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/MRColorR/vnc-browser/docker-ci.yml?style=flat&link=https%3A%2F%2Fgithub.com%2FMRColorR%2Fvnc-browser%2Factions)](https://github.com/MRColorR/vnc-browser/actions)

<a name="info-information_source"></a>

VNC-Browser is a minimal, customizable, Linux-based Docker image designed to provide a lightweight environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Debian and Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Chromium and Firefox web browsers, providing a compact solution for remotely browsing the web. Whether you're looking to browse securely or need a browsing environment within a containerized setup, VNC-Browser has you covered.

**Key Features ✨**

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux and Debian Slim, ensuring minimal resource usage.
- **Customizable**: Set VNC password, initial website URL, auto-start settings, etc. via environment variables to build custom environments (e.g. webkiosk)
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

## Getting started

<a name="available-images-"></a>

### Available images

- `mrcolorrain/vnc-browser:alpine` (with Firefox browser)
- `mrcolorrain/vnc-browser:debian` (with Chromium browser)

<a name="quick-start-"></a>

### Quick Start

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

## Documentation

<a name="customization-"></a>

### Customization

You can customize the settings of the Docker container by passing environment variables during the Docker run command. All the current settings will be printed in the container logs. Here are some examples:
- Setting the initial website URL: `STARTING_WEBSITE_URL="https://www.google.com"`
- Setting the VNC password: `VNC_PASSWORD="mypassword"`
- Setting the resolution: `VNC_RESOLUTION="1280x720"`
- Enabling/disabling auto-start for the browser: `AUTO_START_BROWSER=true` or `AUTO_START_BROWSER=false`
- Enabling/disabling auto-start for xterm: `AUTO_START_XTERM=true` or `AUTO_START_XTERM=false`
- Enabling/disabling auto-start for window manager (fluxbox): `AUTO_START_WM=true` or `AUTO_START_WM=false`
- Enabling/disabling auto-start for vnc (tigervnc): `AUTO_START_VNC=true` or `AUTO_START_VNC=false`
- Enabling/disabling auto-start for noVNC (websockify): `AUTO_START_NOVNC=true` or `AUTO_START_NOVNC=false`
- Adding command options for browser: `BROWSER_OPTIONS="--start-fullscreen --kiosk --incognito --noerrdialogs --no-first-run --disk-cache-dir=/dev/null"`
- Adding command options for vnc (tigervnc): `VNC_OPTIONS="-AlwaysShared"`
- Adding command options for window manager (fluxbox): `WM_OPTIONS="-rc /app/fluxbox.conf"`
- Adding command options for noVNC (websockify): `NOVNC_OPTIONS="--heartbeat=10"`
- Adding command options for xterm: `XTERM_OPTIONS="-leftbar"`

#### Available Variables ⚙️
| Variable               | Default                           | Description |
|------------------------|-----------------------------------|-------------|
| VNC_SCREEN             | 0                                 | Screen number for VNC |
| VNC_DISPLAY            | 0                                 | Display number for VNC |
| VNC_RESOLUTION         | 1280x720                          | Resolution of the VNC display |
| VNC_PASSWORD           | money4band                        | Password for VNC access |
| VNC_PORT               | 5900                              | Port for VNC connections |
| NOVNC_WEBSOCKIFY_PORT  | 6080                              | Port for noVNC web access |
| STARTING_WEBSITE_URL   | https://www.google.com            | Initial website URL opened in the browser if auto startup is true |
| LANG                   | en_US.UTF-8                       | Language setting for the container |
| LC_ALL                 | C.UTF-8                           | Locale setting for the container |
| CUSTOMIZE              | false                             | Toggle for running custom scripts |
| AUTO_START_BROWSER     | true                              | Automatically start the browser |
| AUTO_START_XTERM       | true                              | Automatically start xterm |
| AUTO_START_WM          | true                              | Automatically start window manager (fluxbox) |
| AUTO_START_VNC         | true                              | Automatically start vnc (tigervnc) |
| AUTO_START_NOVNC       | true                              | Automatically start noVNC (websockify) |
| CUSTOM_ENTRYPOINTS_DIR | /app/custom_entrypoints_scripts   | Directory for custom entry point scripts |
| DEBIAN_FRONTEND        | noninteractive                    | Frontend setting for Debian-based installations |
| BROWSER_OPTIONS        |                                   | Additional command options to provide to browser start |
| VNC_OPTIONS            |                                   | Additional command options to provide to vnc (tigervnc) start |
| WM_OPTIONS             |                                   | Additional command options to provide to window manager (fluxbox) start |
| NOVNC_OPTIONS          |                                   | Additional command options to provide to noVNC (websockify) start |
| XTERM_OPTIONS          |                                   | Additional command options to provide to xterm start |


- Example:
```sh
docker run -d -p 5900:5900 -p 6080:6080 -e STARTING_WEBSITE_URL="https://www.bing.com" -e VNC_PASSWORD="mypassword" -e VNC_RESOLUTION="1920x1080" -e AUTO_START_BROWSER=true -e AUTO_START_XTERM=true mrcolorrain/vnc-browser:alpine
```

<a name="adding-custom-entrypoints-"></a>

### Adding Custom Entrypoints

This image allows you to add custom scripts that will be executed when the container starts, provided customization is enabled.

#### Instructions for Custom Entrypoints:
- Use this Image as a Base for Your Custom Image or Mount a Volume and Add Your Scripts to the custom entrypoints Directory:
  - Option 1: Create a new image using this image as the base and copy your custom scripts in the custom entrypoints directory.
  - Option 2: Mount a volume containing your custom scripts to the /app/custom_entrypoints_scripts directory.
    - Example:`docker run -d -p 5900:5900 -p 6080:6080 -v /path/to/your/scripts:/app/custom_entrypoints_scripts -e CUSTOMIZE=true mrcolorrain/vnc-browser:debian`
- More info on custom entrypoints:
  - To customize the image place your .sh (bash) or .py (Python) scripts in the directory and Set the environment variable `CUSTOMIZE=true` to enable custom scripts execution.
    - Ensure your scripts have the necessary permissions (e.g.: make scripts executable).
    - Ensure your scripts starts with the correct shebang (e.g.: #!/bin/bash or #!/usr/bin/env python3)
  - Execution Order:
    - All scripts in this directory will be executed in alphabetical order.
    - It's recommended to put a single bash entrypoint to keep the complexity low.
  - Logs:
    - The execution and output of these scripts can be reviewed in the container logs.

---

## Contributing

Ideas, bug reports, documentation fixes and focused changes are welcome through this repository's collaboration channels.

Please include enough context to reproduce a problem or review a change.

## Support

**🫶 Support the project**

Your contributions are vital in helping to sustain the development of open-source projects and tools made freely available to everyone. If you find value in my work and wish to show your support, kindly consider making a donation.

☕ [Support me on Ko-fi](https://ko-fi.com/mrcolorrain) · 💛 [Donate with cryptocurrency](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md#cryptocurrency-wallets)

Thank you for helping me keep building and sharing! 🙏 See the [supporter directory](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md).

## License

<a name="hash-license"></a>

[GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html)

<a name="warning-disclaimer"></a>

### Disclaimer

This project and its artifacts are provided "as is" and without warranty of any kind.
The author makes no warranties, express or implied, that this script is free of errors, defects, or suitable for any particular purpose.
The author shall not be retained liable for any damages suffered by any user of this script, whether direct, indirect, incidental, consequential, or special, arising from the use of or inability to use this script or its documentation, even if the author has been advised of the possibility of such damages.
