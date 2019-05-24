#!/usr/bin/env bash

[ ! -d "$HOME/vendor/bin" ] && mkdir -p $HOME/vendor/bin

# Install Terraform
curl "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip" -o "terraform_0.11.14_linux_amd64.zip"
unzip terraform_0.11.14_linux_amd64.zip
rm terraform_0.11.14_linux_amd64.zip
mv terraform $HOME/vendor/bin/

