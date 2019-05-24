provider "aws" {
  region = "us-east-1"
}

module "wordpress" {
  source = "../../.."

  region = "us-east-1"

  jumpbox_ip     = "0.0.0.0"
  db_password    = "380cccf909"
  s3_bucket_name = "wordpress-content-${random_string.short.result}"
  s3_elblogs_bucket_name = "wordpress-elblogs-${random_string.short.result}"
  ec2_key_name   = "wordpress"
  ec2_public_key = "${file("${path.root}/../../assets/wordpress.pub")}"

  tags = {
    Service = "WordPress"
  }
  
  # R53 Zone Id passed as environment variable from Travis > Kitchen > TF test module
  #route53_zone_id     = "zone_id" 
  route53_record_name = "wpblog"
  rds_db_identifier   = "rds-${random_string.short.result}"
}

resource "random_string" "short" {
  length = 5
  special = false
}