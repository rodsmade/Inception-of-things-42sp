#!/bin/bash
set -euxo pipefail

SERVER_IP="192.168.56.110"

# Install K3s server (control plane)
if ! systemctl is-active --quiet k3s; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --node-ip ${SERVER_IP} --advertise-address ${SERVER_IP} --tls-san ${SERVER_IP}" sh -
fi

# Setup kubeconfig for the vagrant user
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

# Export artifacts for agents
mkdir -p /vagrant/k3s_artifacts
cp /etc/rancher/k3s/k3s.yaml /vagrant/k3s_artifacts/kubeconfig
sed -i "s/127.0.0.1/${SERVER_IP}/" /vagrant/k3s_artifacts/kubeconfig
cp /var/lib/rancher/k3s/server/node-token /vagrant/k3s_artifacts/node-token
chmod 600 /vagrant/k3s_artifacts/kubeconfig
chmod 640 /vagrant/k3s_artifacts/node-token
chown -R vagrant:vagrant /vagrant/k3s_artifacts
