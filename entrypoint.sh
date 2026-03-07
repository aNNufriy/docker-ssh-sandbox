#!/bin/bash
set -e

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
if [ ! -f $SSHD_CONFIG ]; then
    echo "Creating default sshd_config..."
    touch $SSHD_CONFIG
    echo -e "PermitRootLogin prohibit-password\nPubkeyAuthentication yes\nPasswordAuthentication no\nClientAliveInterval 60\nClientAliveCountMax 5" > /etc/ssh/sshd_config
fi

exec "$@"
