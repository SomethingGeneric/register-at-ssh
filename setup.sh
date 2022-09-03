#!/bin/bash

if [[ ! "$EUID" == "0" ]]; then
    echo "Run as root or with 'sudo'"
    exit 1
fi

if [[ -d /home/register ]]; then
    echo "There's already a user 'register'."
    exit 1
fi

wheres_groupadd=$(which groupadd)
if [[ "$wheres_groupadd" == "" ]]; then
    echo "Couldn't find 'groupadd'"
    exit 1
fi

wheres_sudo=$(which sudo)
if [[ "$wheres_sudo" == "" ]]; then
    echo "Couldn't find 'sudo'"
    exit 1
fi

wheres_openssl=$(which openssl)
if [[ "$wheres_openssl" == "" ]]; then
    echo "Couldn't find 'openssl'"
    exit 1
fi

useradd -m register

usermod --password $(echo "register" | openssl passwd -1 -stdin) register

groupadd -f guests

chmod +x register
cp register /usr/bin/.
usermod --shell /usr/bin/register register