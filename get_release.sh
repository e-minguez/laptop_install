#!/bin/sh
set -eo pipefail

VERSION="27"
ISO="Fedora-Workstation-netinst-x86_64-27-1.6.iso"
CHECKSUM="Fedora-Workstation-27-1.6-x86_64-CHECKSUM"
MIRROR="https://download.fedoraproject.org/pub/fedora/linux/releases/${VERSION}/Workstation/x86_64/iso/"

curl -L -O ${MIRROR}${ISO}
curl -L -O ${MIRROR}${CHECKSUM}
sha256sum -c ${CHECKSUM} 2>/dev/null| grep ${ISO}
