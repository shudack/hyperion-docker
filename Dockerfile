# Debian 13 (Trixie) is LTS until 2030
FROM debian:13-slim

ARG RELEASE_TYPE=stable
ARG HYPERION_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
        wget \
        gnupg \
        dirmngr \
        libgnutls30t64 \
        lsb-release \
        ca-certificates \
        openssl \
        libx11-6 \
        libusb-1.0-0 \
        libftdi1-2 \
        libexpat1-dev \
        libgl-dev \
        libfreetype6 \
        python3; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*

COPY install.sh .

RUN chmod +x install.sh \
    && ./install.sh \
    && rm install.sh

EXPOSE 8090 8092 19400 19444 19445

ENTRYPOINT ["/usr/bin/hyperiond","--userdata","/config"]
