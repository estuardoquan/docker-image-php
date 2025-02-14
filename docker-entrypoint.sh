#!/bin/sh
#set -eo pipefail

if [[ -f "/usr/local/share/ca-certificates/root_ca.crt" ]]; then
    echo "file found"
    update-ca-certificates
fi

exec "${@}"
