#!/usr/bin/env bash
# Generate the SSH key pair used by the EC2 examples.
# The private key stays local (gitignored); only the .pub is referenced by Terraform.
set -euo pipefail
KEY_NAME="${1:-terra-key-ec2}"
ssh-keygen -t rsa -b 4096 -f "./${KEY_NAME}" -N "" -C "terraform-demo"
echo "Created ./${KEY_NAME} (private) and ./${KEY_NAME}.pub (public)"
echo "Never commit the private key."
