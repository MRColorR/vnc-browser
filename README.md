# VNC-Browser

<!-- Project README scaffold: https://github.com/MRColorR/project-template -->

**Run a browser in Docker and connect to it over VNC.**

[**🚀 Run the Docker image**](#getting-started) · [📚 Documentation](#documentation) · [🫶 Support](#support)

<p align="center">
  <strong>Leave a star ⭐ if you like this project 🙂 Thank you!</strong>
</p>

<a name="overview"></a>

## 🔍 Overview

A Lightweight, Ready-to-Use Web Browsing Environment in Docker with VNC Access


[![Docker Pulls](https://img.shields.io/docker/pulls/mrcolorrain/vnc-browser?style=flat-square&link=https://hub.docker.com/r/mrcolorrain/vnc-browser)](https://hub.docker.com/r/mrcolorrain/vnc-browser)
[![Docker Stars](https://img.shields.io/docker/stars/mrcolorrain/vnc-browser?style=flat-square&link=https://hub.docker.com/r/mrcolorrain/vnc-browser)](https://hub.docker.com/r/mrcolorrain/vnc-browser)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/MRColorR/vnc-browser/docker-ci.yml?style=flat&link=https%3A%2F%2Fgithub.com%2FMRColorR%2Fvnc-browser%2Factions)](https://github.com/MRColorR/vnc-browser/actions)

<a name="info-information_source"></a>

VNC-Browser is a minimal, customizable, Linux-based Docker image designed to provide a lightweight environment for browsing the web via VNC.
This Docker image encapsulates a lightweight, VNC-accessible web browsing environment built on top of Debian and Alpine Linux. It packages a VNC server, noVNC for browser-based VNC access, and the Chromium and Firefox web browsers, providing a compact solution for remotely browsing the web. Use it for a dedicated browser session on a machine you control.

**Key Features ✨**

- **VNC-Ready**: Ready for use with any VNC client or through a web browser using noVNC, offering a user-friendly interface.
- **Lightweight**: Built on Alpine Linux and Debian Slim, ensuring minimal resource usage.
- **Customizable**: Set VNC password, initial website URL, auto-start settings, etc. via environment variables to build custom environments (e.g. webkiosk)
- **Accessible**: Access the VNC server directly or through a browser using noVNC.

<a name="getting-started"></a>

## 🚥 Getting started

<a name="available-images-"></a>

### Available images

- `mrcolorrain/vnc-browser:alpine` (with Firefox browser)
- `mrcolorrain/vnc-browser:debian` (with Chromium browser)

<a name="quick-start-"></a>

### Quick Start

You can run it easily using its default or by passing the appropriate environment variables.

- ### Docker CLI 🐳
  ```bash
  docker run -d -p 127.0.0.1:5900:5900 -p 127.0.0.1:6080:6080 --name vnc-browser -e VNC_PASSWORD="mypassword" mrcolorrain/vnc-browser:debian
  ```

- ### Docker Compose 🐳
  ```yaml
  version: "3.9"
  services:
    vnc-browser:
      container_name: vnc-browser
      image: mrcolorrain/vnc-browser:debian
      ports:
        - "127.0.0.1:5900:5900"
        - "127.0.0.1:6080:6080"
      environment:
        VNC_PASSWORD: "mypassword"
      restart: unless-stopped
    ```
After starting it then you can connect by:
- Using a browser, you can connect to the noVNC client on `localhost:6080`
- Using a VNC Client, you can connect to `localhost:5900`

> Replace the example password before use. Keep both ports on localhost and use an SSH tunnel for remote access. Chromium runs as root with its browser sandbox disabled, so use this image for trusted sessions rather than as a security boundary.

<a name="documentation"></a>

## 📚 Documentation

<a name="customization-"></a>

### Customization

You can customize the settings of the Docker container by passing environment variables during the Docker run command. Startup settings are printed in the container logs; the VNC password is hidden. Here are some examples:
- Setting the initial website URL: `STARTING_WEBSITE_URL="https://www.google.com"`
- Setting the VNC password: `VNC_PASSWORD="mypassword"`
- Setting the resolution: `VNC_RESOLUTION="1280x720"`
- Switch to a dark browser theme, dark xterm colors and a dark Fluxbox desktop with `-e THEME=dark` in Docker or `THEME: dark` under `environment` in Compose.
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
| THEME                  | light                             | Theme for the browser, xterm and Fluxbox. Use `light` or `dark`. Other values, including an empty value, stop startup with an error. |
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
docker run -d -p 127.0.0.1:5900:5900 -p 127.0.0.1:6080:6080 -e STARTING_WEBSITE_URL="https://www.bing.com" -e VNC_PASSWORD="mypassword" -e VNC_RESOLUTION="1920x1080" -e AUTO_START_BROWSER=true -e AUTO_START_XTERM=true mrcolorrain/vnc-browser:alpine
```

### Keep your browser profile 💾

Mount a named volume to keep bookmarks, cookies and logins when recreating a container:

| Image | Profile directory |
|-------|-------------------|
| Debian (Chromium) | `/root/.config/chromium` |
| Alpine (Firefox) | `/root/.config/mozilla` |

If you already have a Firefox profile volume at `/root/.mozilla`, keep its existing mount.

For Chromium, keep the same hostname when recreating the container so its profile lock recognizes the device:

```bash
docker run -d --name vnc-browser --hostname vnc-browser \
  -p 127.0.0.1:5900:5900 -p 127.0.0.1:6080:6080 \
  -e VNC_PASSWORD="mypassword" \
  -v browser-profile:/root/.config/chromium \
  mrcolorrain/vnc-browser:debian
```

In Compose, set `hostname: vnc-browser` and mount the volume under `volumes`. Use a separate profile volume for each browser instance. Stop the old container before reusing its profile, and use `docker stop` to let the browser close cleanly. This preserves saved browser data, not a running process or unsaved form input.

If Chromium reports that the profile is in use, first check that no other container is using the volume. Do not delete profile locks while a browser is running.

<a name="adding-custom-entrypoints-"></a>

### Adding Custom Entrypoints

This image allows you to add custom scripts that will be executed when the container starts, provided customization is enabled.

#### Instructions for Custom Entrypoints:
- Use this Image as a Base for Your Custom Image or Mount a Volume and Add Your Scripts to the custom entrypoints Directory:
  - Option 1: Create a new image using this image as the base and copy your custom scripts in the custom entrypoints directory.
  - Option 2: Mount a volume containing your custom scripts to the /app/custom_entrypoints_scripts directory.
    - Example: `docker run -d -p 127.0.0.1:5900:5900 -p 127.0.0.1:6080:6080 -v /path/to/your/scripts:/app/custom_entrypoints_scripts -e CUSTOMIZE=true -e VNC_PASSWORD="mypassword" mrcolorrain/vnc-browser:debian`
- More info on custom entrypoints:
  - To customize the image place your .sh (bash) or .py (Python) scripts in the directory and Set the environment variable `CUSTOMIZE=true` to enable custom scripts execution.
    - Ensure your scripts have the necessary permissions (e.g.: make scripts executable).
    - Ensure your scripts starts with the correct shebang (e.g.: #!/bin/bash or #!/usr/bin/env python3)
  - Execution Order:
    - All scripts in this directory will be executed in alphabetical order.
    - It's recommended to put a single bash entrypoint to keep the complexity low.
  - Logs:
    - The execution and output of these scripts can be reviewed in the container logs.

Custom scripts run after services start, following a 10-second startup delay. When they finish, the container keeps running until Supervisor stops. A failed script stops startup with a nonzero exit code. Use scripts that finish, rather than long-running foreground services; manage additional services through Supervisor. Shell scripts must use Unix (LF) line endings. Python hooks require Python 3 in the image.

---

<a name="contributing"></a>

## 🤝 Contributing

Ideas, bug reports, documentation fixes and focused changes are welcome through this repository's collaboration channels.

Please include enough context to reproduce a problem or review a change.

To run the Docker integration checks locally (Python 3 and Docker required):

```bash
docker build -f debian.dockerfile -t vnc-browser-test:debian .
python3 tests/test_container.py vnc-browser-test:debian chromium
docker build -f alpine.dockerfile -t vnc-browser-test:alpine .
python3 tests/test_container.py vnc-browser-test:alpine firefox
```

The checks cover startup, restart, shutdown, custom scripts, password logging and browser profile persistence. Test containers and volumes are removed automatically.

<a name="support"></a>

## 🫶 Support

**🫶 Support the project**

Your contributions are vital in helping to sustain the development of open-source projects and tools made freely available to everyone. If you find value in my work and wish to show your support, kindly consider making a donation.

☕ [Support me on Ko-fi](https://ko-fi.com/mrcolorrain) · 💛 [Donate with cryptocurrency](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md#cryptocurrency-wallets)

Thank you for helping me keep building and sharing! 🙏 See the [supporter directory](https://github.com/MRColorR/MRColorR/blob/main/SUPPORTERS.md).

<a name="license"></a>

## 📄 License

<a name="hash-license"></a>

[GPL 3.0](https://www.gnu.org/licenses/gpl-3.0.html)

<a name="warning-disclaimer"></a>

### Disclaimer

This project and its artifacts are provided "as is" and without warranty of any kind.
The author makes no warranties, express or implied, that this script is free of errors, defects, or suitable for any particular purpose.
The author shall not be retained liable for any damages suffered by any user of this script, whether direct, indirect, incidental, consequential, or special, arising from the use of or inability to use this script or its documentation, even if the author has been advised of the possibility of such damages.
