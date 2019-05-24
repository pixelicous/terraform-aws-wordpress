#!/usr/bin/env bash

mkdir tools/bin

# Install Terraform
wget -q https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terraform_0.11.11_linux_amd64.zip
rm terraform_0.11.11_linux_amd64.zip
mv terraform tools/bin/

