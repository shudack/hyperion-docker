# Debian 12 (Bookworm) is LTS until 2028
FROM debian:12-slim
ARG RELEASE_TYPE=STABLE

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
        wget \
        gnupg \
        dirmngr \
        libgnutls30 \
        lsb-release \
        ca-certificates \
        libqt5sql5-sqlite \
        openssl \
        libx11-6 \
        libusb-1.0-0 \
        libftdi1-2 \
        libexpat-dev \
        libgl-dev \
        libfreetype6 \
        python3 \
        python3-distutils; \
    apt-get clean -y; \
    rm -rf /var/lib/apt/lists/*

# Copy and install Hyperion
COPY install.sh .
RUN chmod +x install.sh && ./install.sh && rm install.sh

EXPOSE 8090 8092 19400 19444 19445

ENTRYPOINT ["/usr/bin/hyperiond"]
