#!/bin/bash

OS=$(uname)
GLIBC=UNKNOWN-0.0.0

function get_os_version {
    source /etc/os-release
    os_release="${NAME} ${VERSION_ID}"
}

case $OS in
Linux*)
    if ldd --version 2>&1 | grep -i musl > /dev/null; then
        get_os_version
        GLIBC="MUSL-$(ldd --version 2>&1 | grep Version | cut -d\  -f2) ($os_release)"
    else
        get_os_version
        GLIBC="GLIBC-$(ldd --version 2>&1  | grep ^ldd | awk '{print $(NF)}') ($os_release)"
    fi
    ;;
Darwin*)
    GLIBC=DARWIN-$(sw_vers | grep ProductVersion | cut -d$'\t' -f2)
    ;;
*)
  ;;
esac

echo $GLIBC