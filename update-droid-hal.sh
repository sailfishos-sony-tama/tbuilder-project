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

# main device from which common packages are synced
main_device=h8324

# helper functions
sync_type() {
    local fam=$1
    local device=$2
    mkdir -p RPMS/$sfos_target/
    for files in \
	droid-hal-*/droid-hal \
	    droid-hal-img-dtbo-sony-tama-pie/droid-hal-*-img-dtbo \
	    droid-system-sony-pie-template/droid-system
    do
	rsync -av $ANDROID_ROOT/droid-local-repo/$device/${files}* RPMS/$sfos_target/
    done
}

sync_dev() {
    local fam=$1
    local device=$2
    for files in \
	    droid-system-sony-pie-template/droid-system-$fam-$device
    do
	rsync -av $ANDROID_ROOT/droid-local-repo/$device/${files}* RPMS/$sfos_target/
    done
}

### main ###

# sync device-specific
sync_type apollo h8324
sync_dev apollo h8314
sync_dev apollo h8324
sync_type akari h8216
sync_dev akari h8216

# sync common
mkdir -p common/RPMS/$sfos_target/

for files in \
    miniaudiopolicy/miniaudiopolicy \
    droidmedia-localbuild/droidmedia
do
    rsync -av $ANDROID_ROOT/droid-local-repo/$main_device/${files}* RPMS/$sfos_target/
done
