#!/bin/bash
set -euxo pipefail

SERVER_IP="192.168.56.110"
TOKEN="12345"

# Install K3s server (control plane)
if ! systemctl is-active --quiet k3s; then
    curl -sfL https://get.k3s.io | \
      INSTALL_K3S_EXEC="server \
        --node-ip ${SERVER_IP} \
        --advertise-address ${SERVER_IP} \
        --tls-san ${SERVER_IP} \
        --token ${TOKEN}" sh -
    echo "K3s server installed and running."
else
    echo "K3s server already running, skipping."
fi
