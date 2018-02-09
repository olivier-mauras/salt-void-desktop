#!/bin/sh
KERN_LIST=`ls /boot/vmlinuz-* | cut -f 2 -d - | cut -f -2 -d . | sort | uniq`
for KERN_VER in ${KERN_LIST}; do
  xbps-reconfigure -f linux${KERN_VER}
done
