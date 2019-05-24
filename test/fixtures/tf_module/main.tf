terraform {
  required_version = "= 0.11.14"
}

provider "aws" {
  region = "us-east-1"
}

module "wordpress" {
  source = "../../.."

  # Custom sensitive values which are passed as environment variable from Travis > Kitchen > TF test module
  # Travis ip is taken during execution and passed as variable

  route53_zone_id     = "${var.route53_zone_id}" 
  jumpbox_ip     = "${var.jumpbox_ip}"
  
  region = "us-east-1"
  db_password    = "380cccf909"
  s3_bucket_name = "wordpress-content-${random_string.short.result}"
  s3_elblogs_bucket_name = "wordpress-elblogs-${random_string.short.result}"
  ec2_key_name   = "wordpress"
  ec2_public_key = "${file("${path.root}/../../assets/wordpress.pub")}"

  tags = {
    Service = "WordPress"
  }
  
  route53_record_name = "wpblog"
  rds_db_identifier   = "rds-${random_string.short.result}"
}

resource "random_string" "short" {
  length = 5
  upper = false
  special = false
}

variable "route53_zone_id" {
  type = "string"
}

variable "jumpbox_ip" {
  type = "string"
}