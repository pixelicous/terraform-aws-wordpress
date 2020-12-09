[![MIT license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Release](https://img.shields.io/github/release/pixelicous/terraform-aws-wordpress.svg)](https://github.com/pixelicous/terraform-aws-wordpress/releases)
[![Build Status](https://travis-ci.org/pixelicous/terraform-aws-wordpress.svg?branch=master)](https://travis-ci.org/pixelicous/terraform-aws-wordpress)
[![Support me via PayPal](https://img.shields.io/badge/PayPal-Support-orange.svg?style=flat&logo=paypal)](https://www.paypal.me/pixeIabs)

My repo contains outdated HCL.
I stopped development of this package. Serve this here for educational purposes

# WordPress AWS Best Practice Module
This repo's root folder contains a wordpress terraform module for deploying a fully redundant and highly available WordPress site.
As of version 1.0.0 this module creates a new VPC with an internet gateway and a routing table.
An option to use the default or existing VPC will be added in future version.

> Please check [CHANGELOG](CHANGELOG.md) for future features and/or bug fixes.\

## Support
If you've find any value from the content I created, some support would be very much appreciated :)

[![Buy me a coffee](https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png)](https://www.buymeacoffee.com/pixelabs)&nbsp;&nbsp;&nbsp;&nbsp;[![Support me via PayPal](https://cdn.rawgit.com/twolfson/paypal-github-button/1.0.0/dist/button.svg)](https://www.paypal.me/pixeIabs/)

## Usage
* An example for using this module exists in the [examples](examples/) folder.
* Fetch certificate in case you want to use SSL on NLB. Uncomment "listener" parameter under aws_elb in network.tf
* As terraform currently cannot create a key pair, please create one manually. Afterwards download the private key `
  to your root module folder at "./ssh". Set "ec2_key_name" variable to the same filename (without PEM file prefix).

An example of using the module in existing code:
```hcl
module "wordpress" {
  source = "git::https://github.com/pixelicous/terraform-aws-wordpress.git?ref=master"

  region = "${var.region}"
  jumpbox_ip = "142.142.142.142"
  ec2_key_name = "wordpres"
  s3_bucket_name = "wordpress-elb-logs-somesite"
  route53_record_name = "wordpressweb"
  route53_zone_id = "XXXXXXXXXXXXXX"
  rds_db_identifier = "wpsomesitedb"

  tags = "${var.tags}
}
```

## Architecture
The architecture is based of AWS' WordPress deployment best practices.
![AWS Reference Architecture](https://github.com/pixelicous/terraform-aws-wordpress/blob/master/images/aws-refarch-wordpress.jpeg?raw=true)


## Information about EC2 VM deployment
* The EC2 AMI is based of Bitnami's Debian WordPress installation.
After EC2 is provisioned the following configuration steps will be executed:
1. MySQL database will be backed up and copied to Amazon RDS, wp-config.php on EC2 will be set accordingly.
2. The local MySQL service will be stopped and disabled.
3. The "WP Offload Media Lite" for Amazon S3 will be installed and activated.

This step runs as part of a "null resource", in order to wait for EC2, RDS and related security groups to be provisioned first.

## Testing
The repository contains TravisCI and KitchenCI files for some basic tests.
The test artifacts are found at the [test folder](test/):
* [Assets](test/assets/) - Binaries, currently kitchen generates a key pair for EC2 instance to this folder.
* [Fixtures](test/fixtures/tf_module/) - Includes a test Terraform module for KitchenCI.
* [Integration](test/integration/test_suite/controls/) - Includes a test suite with the following tests:
  1. Communication to NLB over port 80
  2. SSH over port 22 from the public ip which is set as jumpbox_ip.
Operating system parameters are checked and so is a basic terraform state version check.
> The terraform variables values for: "jumpbox_ip" and "route53_zone_id" are imported from environment variables as  they are usually provided as sensitive values from CI system.
In order to do local testing I would recommend to create a .env file as follows:
```bash
export JUMPBOX_IP="JUMPBOX_IP"
export ROUTE53_ZONE_ID="R53_ZONE_ID"
export AWS_ACCESS_KEY_ID="KEY"
export AWS_SECRET_ACCESS_KEY="SECRET"
export AWS_DEFAULT_REGION="REGION"
```


## References
* https://github.com/aws-samples/aws-refarch-wordpress
* https://d1.awsstatic.com/whitepapers/wordpress-best-practices-on-aws.pdf
* https://aws-quickstart.s3.amazonaws.com/quickstart-bitnami-wordpress/doc/wordpress-high-availability-by-bitnami-on-the-aws-cloud.pdf

## Authors
Module managed by [Netzer Rom](https://github.com/pixelicous).

## License
MIT Licensed. See LICENSE for full details.

