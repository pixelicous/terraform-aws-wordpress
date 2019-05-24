#!/usr/bin/env bash

# Add binaries to bin directory
mkdir -p tools/bin
export PATH=$PATH:tools/bin:tools/aws-sdk/bin

# Install AWS CLI
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
sudo apt-get -y install unzip
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
/usr/local/bin/aws --version

# Authenticate
# Make a directory to contain the key
mkdir -p test/assets

# Generate a 4096 bit RSA key with a blank passphrase in the directory
# Add "-m pem" if running from OSX mojave
ssh-keygen -b 4096 -C "Kitchen-Terraform AWS provider tutorial" -f test/assets/wordpress -N "" -t rsa


# Run test
bundle exec kitchen test --destroy always
KITCHEN_EXIT_CODE=$? #Save exit code to exit with it, but still clean up no matter the code


exit $KITCHEN_EXIT_CODE