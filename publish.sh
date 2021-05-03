#!/bin/bash

# script used to publish RPMS

set -e

# generate index.html used to show overview page
tree -h -T "Sailfish OS Packages for Sony Tama" --noreport -D -L 2 -F --dirsfirst -P "*.rpm" -H RPMS RPMS > RPMS/index.html
# default error page
echo "Error, file or directory not found or not accessible via this URL" > RPMS/error.txt

# sync
minmc mirror --remove --overwrite RPMS/ scw/sailfishos-sony-tama/
