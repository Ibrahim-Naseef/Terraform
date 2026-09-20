#!/usr/bin/env bash
# Install Terraform on Debian/Ubuntu.
# Docs: https://developer.hashicorp.com/terraform/install
set -euo pipefail

echo "==> Adding HashiCorp GPG key"
wget -qO- https://apt.releases.hashicorp.com/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "==> Adding HashiCorp apt repository"
CODENAME="$(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs)"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

echo "==> Installing Terraform"
sudo apt-get update -y
sudo apt-get install -y terraform

terraform version
