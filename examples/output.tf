output "elb_fqdn" {
    description = "The ELB fully qualified domain name."
    value = "${module.wordpress.elb_fqdn}"
}

output "ec2_ip" {
    description = "WordPress EC2 instance IP address."
    value = "${module.wordpress.ec2_ip}"
}

output  "rds_host" {
    description = "The RDS host instance."
    value = "${module.wordpress.rds_host}"
}