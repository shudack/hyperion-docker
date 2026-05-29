#!/bin/sh

set -eux

# Import the Hyperion repository GPG key
wget --no-check-certificate -qO- https://apt.hyperion-project.org/hyperion.pub.key \
    | gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg

# Get Debian codename (e.g., bookworm)
CODENAME=$(lsb_release -cs)

if [ "${RELEASE_TYPE}" = "nightly" ]; then
    echo "Installing Hyperion Nightly"
    echo "deb [signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://nightly.apt.releases.hyperion-project.org/ ${CODENAME} main" \
        | tee /etc/apt/sources.list.d/hyperion.nightly.list
else
    echo "Installing Hyperion Stable"
    echo "deb [signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.hyperion-project.org/ ${CODENAME} main" \
        | tee /etc/apt/sources.list.d/hyperion.list
fi

apt-get update
apt-get install -y hyperion

apt-get clean -y
rm -rf /var/lib/apt/lists/*
