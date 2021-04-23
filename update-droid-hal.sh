#!/bin/bash

# script for updating droid-hal-* and similar packages

set -e

if [ $# -eq 0 ]
then
    echo "Missing SFOS target"
    exit 1
fi
if [ -z "$ANDROID_ROOT" ]
then
    echo "ANDROID_ROOT variable is not defined in the shell"
    exit 1
fi

sfos_target=$1

# later make a loop over $device
device=h8324

mkdir -p RPMS/$sfos_target/

for files in \
    droid-hal-$device/droid-hal \
	droid-hal-img-dtbo-sony-tama-pie/droid-hal-*-img-dtbo \
	miniaudiopolicy/miniaudiopolicy \
	droid-system-sony-pie-template/droid-system
do
    rsync -av $ANDROID_ROOT/droid-local-repo/${device}/${files}* RPMS/$sfos_target/
done
