output "elb_fqdn" {
    description = "The ELB fully qualified domain name"
    value = "${aws_elb.wordpress.dns_name}"
}

output "ec2_ip" {
    description = "WordPress EC2 instance IP address."
    value = "${aws_eip.wordpress.public_ip}"
}

output  "rds_host" {
    description = "The RDS host instance."
    value = "${aws_db_instance.wordpress.address}"
}