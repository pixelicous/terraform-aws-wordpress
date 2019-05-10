
#--------------------------------------------------------
### General

variable "region" {
  description = "(Required) The region the resources will be provisioned to."
  type        = "string"
}

variable "tags" {
  description = "Specifies object tags key and value."
  type        = "map"
  default = {}
}

#--------------------------------------------------------
### Route 53

variable "availability_zone" {
  description = "Main availability zone for resources with no high availability."
  type        = "string"
  default     = "us-east-1d"
}

variable "availability_zones" {
  description = "Availability zones for highly available resources."
  type        = "list"

  default = [
    "us-east-1a",
    "us-east-1d",
  ]
}

variable "jumpbox_ip" {
  description = "(Required) The jumpbox ip address used to administer the EC2 instance (For SSH communication)."
  type        = "string"
}

variable "elb_ssl_cert" {
  description = "If using SSL certificate on ELB, provide certificate ARN."
  type        = "string"
  default     = ""
}

variable "s3_bucket_name" {
  description = "(Optional, Forces new resource) The name of the bucket to host Wordpress objects. If omitted, Terraform will assign a random, unique name."
  default = ""
}


#--------------------------------------------------------
### Compute

variable "ec2_instance_type" {
  description = "The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance."
  type = "string"
  default = "t2.micro"
}

variable "ami_images" {
  description = "The Bitnami WordPress AMI used for EC2 VM."
  type        = "map"

  default = {
    us-east-1 = "ami-016998b436031d351"
    us-east-2 = ""
  }

}

# Currently TF doesn't support creation of key pair, need to create manually.
# https://www.terraform.io/docs/providers/aws/r/key_pair.html
variable "ec2_key_name" {
  description = "(Required) The key name of the key pair created for the instance."
  type = "string"
}

#--------------------------------------------------------
### Route 53

variable "route53_zone_id" {
  description = "The ID of the hosted zone to contain the WordPress DNS records."
  type = "string"
}
variable "route53_record_name" {
  description = "The name of the EC2 instance DNS record."
  type = "string"
}

#--------------------------------------------------------
### Database
variable "rds_instance_type" {
  description = "(Required) The instance type of the RDS instance."
  type = "string"
  default = "db.t2.micro"
}
variable "rds_db_identifier" {
  description = "(Optional, Forces new resource) The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier."
  type = "string"
  default = ""
}

# -------------------------------------------------------
# db_password variable below should not be provided until feature to change the database user password is implemented
# else the database backed up to rds will not be available.
variable "db_password" {
  description = "DO NOT CHANGE - Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file."
  default = "380cccf909"
  type = "string"
}
