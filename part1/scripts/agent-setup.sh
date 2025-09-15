#!/bin/bash
set -euxo pipefail

SERVER_IP="192.168.56.110"
AGENT_IP="192.168.56.111"
TOKEN="12345"

# Wait for server API to be ready
# until curl -sf https://${SERVER_IP}:6443/healthz >/dev/null 2>&1; do
#     echo "Waiting for K3s server at ${SERVER_IP}:6443..."
#     sleep 5
# done
until curl -sk -o /dev/null -w "%{http_code}" https://${SERVER_IP}:6443/healthz | grep -qE "200|401"; do
    echo "Waiting for K3s server at ${SERVER_IP}:6443..."
    sleep 5
done

# Install K3s agent (worker node)
if ! systemctl is-active --quiet k3s-agent; then
    curl -sfL https://get.k3s.io | \
      INSTALL_K3S_EXEC="agent \
        --server https://${SERVER_IP}:6443 \
        --token ${TOKEN} \
        --node-ip ${AGENT_IP}" sh -
    echo "K3s agent installed and connected."
else
    echo "K3s agent already running, skipping."
fi
