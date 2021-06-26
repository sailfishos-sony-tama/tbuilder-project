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
	droid-hal-h*/droid-hal \
	    droid-system-sony-pie-template/droid-system
    do
	rsync -av $ANDROID_ROOT/droid-local-repo/$device/${files}* RPMS/$sfos_target/
    done

    RSYNC_DTBO=$(rsync -aEim --no-R --no-implied-dirs $ANDROID_ROOT/out/target/product/$fam/dtbo.img src/droid-hal-img-dtbo-sony-tama-pie/dtbo-$fam.img)
    if [ $? -eq 0 ]; then
	if [ -n "${RSYNC_DTBO}" ]; then
	    echo DTBO updated for $fam
	    touch src/droid-hal-img-dtbo-sony-tama-pie/rpm/droid-hal-$fam-img-dtbo.spec
	else
	    # No changes were made by rsync
	    echo DTBO not changed
	fi
    else
	echo Error while updating DTBO
	exit 1
    fi
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
sync_dev akari h8266

sync_type akatsuki h8416
sync_dev akatsuki h8416
sync_dev akatsuki h9436

for files in \
    miniaudiopolicy/miniaudiopolicy \
    droidmedia-localbuild/droidmedia \
    sailfish-fpd-community/droid-biometry-fp
do
    rsync -av $ANDROID_ROOT/droid-local-repo/$main_device/${files}* RPMS/$sfos_target/
done
