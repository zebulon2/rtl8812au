#!/bin/bash

if ! [ $EUID = 0 ]; then
  echo -e "You must run this with \e[1;91msuperuser\e[0m priviliges." 2>&1
  echo -e 'Try "\e[1;91msudo\e[0m '"${BASH_SOURCE}"'"' 2>&1
  exit 1
fi

echo "About to run dkms install steps..."

DRV_NAME=rtl8812au
DRV_MODNAME=8812au
DRV_VERSION=5.1.5
DRV_USR_SRC="/usr/src/${DRV_NAME}-${DRV_VERSION}"

mkdir -p "${DRV_USR_SRC}"
git archive --format=tar.gz --worktree-attributes --verbose HEAD | tar -xz -C "${DRV_USR_SRC}"
sed -i s/#MODULE_VERSION#/"${DRV_VERSION}"/ "${DRV_USR_SRC}/dkms.conf"
sed -i s/#MODULE_MODNAME#/"${DRV_MODNAME}"/ "${DRV_USR_SRC}/dkms.conf"

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION} && modprobe ${DRV_MODNAME} --verbose
RESULT=$?

echo "Finished running dkms install steps."

exit $RESULT
