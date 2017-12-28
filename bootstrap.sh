#!/bin/bash
REPOURL="https://github.com/e-minguez/laptop_install.git"
GITDIR="${HOME}/git"
GITREPO="${GITDIR}/laptop_install"

sudo dnf install -y ansible git dnf-plugins-core libselinux-python

mkdir -p ${GITDIR}

git clone ${REPOURL} ${GITREPO}

echo "Edit ${GITREPO}/myvars.yaml to fit your needs"
echo "Then run:"
echo "ansible-playbook -K -i inventory.yaml -e @myvars.yml ansible/all.yaml"
