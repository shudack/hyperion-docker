#!/usr/bin/env bash

set -euxo pipefail

wget -qO- https://apt.hyperion-project.org/hyperion.pub.key \
    | gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg

CODENAME="$(lsb_release -cs)"

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

if [ "${RELEASE_TYPE}" = "stable" ] && [ -n "${HYPERION_VERSION:-}" ]; then
    echo "Requested Hyperion version: ${HYPERION_VERSION}"

    PACKAGE_VERSION="$(
        apt-cache madison hyperion \
        | awk -v ver="${HYPERION_VERSION}" '$3 ~ "^" ver "([~-]|$)" { print $3; exit }'
    )"

    if [ -z "${PACKAGE_VERSION}" ]; then
        echo "ERROR: Hyperion version ${HYPERION_VERSION} not found in APT repository."
        echo "Available versions:"
        apt-cache madison hyperion || true
        exit 1
    fi

    echo "Installing Hyperion package version: ${PACKAGE_VERSION}"
    apt-get install -y "hyperion=${PACKAGE_VERSION}"
else
    echo "Installing latest Hyperion ${RELEASE_TYPE}"
    apt-get install -y hyperion
fi

apt-get clean -y
rm -rf /var/lib/apt/lists/*
