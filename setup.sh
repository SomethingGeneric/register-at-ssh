#!/bin/bash

if [[ "$1" == "" || "$1" == "install" ]]; then
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

    cp register /usr/bin/.
    usermod --shell /usr/bin/register register

    wheres_usermod=$(which usermod)
    wheres_useradd=$(which useradd)
    wheres_passwd=$(which passwd)

    echo "register ALL = (root) NOPASSWD: ${wheres_usermod}" >> /etc/sudoers
    echo "register ALL = (root) NOPASSWD: ${wheres_useradd}" >> /etc/sudoers
    echo "register ALL = (root) NOPASSWD: ${wheres_passwd}" >> /etc/sudoers
    echo "Install complete."
elif [[ "$1" == "uninstall" ]]; then
    sudo userdel register
    sudo rm -rfv /home/register
    echo "Uninstall complete. FYI: Users made with this script are still around, obviously."
fi