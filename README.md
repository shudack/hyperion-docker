# shudack/hyperion-ng Docker Image

[
  ![](https://img.shields.io/docker/v/shudack/hyperion-ng?style=plastic&sort=date)
  ![](https://img.shields.io/docker/pulls/shudack/hyperion-ng?style=plastic)
  ![](https://img.shields.io/docker/stars/shudack/hyperion-ng?style=plastic)
  ![](https://img.shields.io/docker/image-size/shudack/hyperion-ng?style=plastic)
  ![](https://img.shields.io/github/actions/workflow/status/shudack/hyperion-docker/build.yml?branch=main&style=plastic)
](https://hub.docker.com/repository/docker/shudack/hyperion-ng)
[
  ![](https://img.shields.io/github/last-commit/shudack/hyperion-docker?style=plastic)
](https://github.com/shudack/hyperion-docker)

<img width="1000" height="240" alt="image" src="https://github.com/user-attachments/assets/c8d28eec-c56d-4782-ba62-14825b3d23f7" />

# Overview
This is an unofficial Hyperion NG Docker image, designed for users who want a lightweight, auto‑updating, x86_64‑compatible installation of Hyperion NG.
The image is based on Debian 12‑slim and automatically downloads and installs the latest available Hyperion NG release for x86_64 during build time.

Hyperion NG provides a powerful Ambilight‑style LED control system with support for USB grabbers, LED strips, effects, and multiple input sources. This container makes deployment simple, reproducible, and hardware‑friendly.

- GitHub: [hyperion-project/hyperion.ng](https://github.com/hyperion-project/hyperion.ng)
- Official site: [https://hyperion-project.org](https://hyperion-project.org)

# Features
- Automatic Release Installation — Downloads and installs the latest Hyperion NG x86_64 .deb package during build.
- Lightweight Base Image — Built on Debian 12‑slim for minimal footprint.
- Full Hardware Support — USB, serial, SPI, and video capture devices can be passed through.
- Persistent Configuration — Uses /config volume for storing settings.
- Web UI Included — Access the Hyperion dashboard on port 8090.
- API Support — JSON, Protobuf, and WebSocket APIs exposed.

# Ports
- 8090 — Web UI
- 8092 — WebSocket API
- 19400 — Protobuf API
- 19444 — JSON API
- 19445 — FlatBuffer API

# Volume
/config — Stores all Hyperion NG configuration files.

# Hardware Access
You can pass devices directly into the container:
- USB/Serial Devices — /dev/ttyUSB0
- SPI Devices — /dev/spidev0.0
- Video Grabbers — /dev/video0

Example:
```
--device /dev/ttyUSB0 \
--device /dev/spidev0.0 \
--device /dev/video0
```

# Default Command
Hyperion NG starts automatically:
```
/usr/bin/hyperiond -u /config
```

# Docker-compose example
```
services:
  hyperion:
    image: shudack/hyperion-ng:latest
    container_name: hyperion
    # privileged: true # For PW
    restart: unless-stopped
    ports:
      - 8090:8090    # Web UI
      - 8092:8092    # WebSocket API
      - 19400:19400  # Protobuf API
      - 19444:19444  # JSON API
      - 19445:19445  # FlatBuffer API
    volumes:
      - /path/to/config:/config
    devices:
      # - /dev/ttyUSB0:/dev/ttyUSB0     # Serial/USB LED controllers
      # - /dev/spidev0.0:/dev/spidev0.0 # SPI LED controllers
      - /dev/video0:/dev/video0       # USB video grabber
```
