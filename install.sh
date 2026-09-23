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

    APT_VERSION="$(
        apt-cache policy hyperion |
        awk '/Candidate:/ {print $2}'
    )"

    if [ -z "${APT_VERSION}" ] || [ "${APT_VERSION}" = "(none)" ]; then
        echo "ERROR: Hyperion package is not available from the configured APT repository."
        exit 1
    fi

    APT_UPSTREAM_VERSION="${APT_VERSION%%-*}"

    echo "APT candidate version: ${APT_VERSION}"
    echo "APT upstream version: ${APT_UPSTREAM_VERSION}"

    if [ "${APT_UPSTREAM_VERSION}" != "${HYPERION_VERSION}" ]; then
        echo "ERROR: Requested Hyperion ${HYPERION_VERSION}, but APT provides ${APT_VERSION}"
        exit 1
    fi

    echo "Installing exact APT package version: ${APT_VERSION}"
    apt-get install -y "hyperion=${APT_VERSION}"
else
    echo "Installing latest Hyperion ${RELEASE_TYPE}"
    apt-get install -y hyperion
fi

apt-get clean -y
rm -rf /var/lib/apt/lists/*
