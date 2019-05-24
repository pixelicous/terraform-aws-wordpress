output "elb_fqdn" {
    description = "The DNS name of the ELB"
    value = "${module.wordpress.elb_fqdn}"
}

output "ec2_ip" {
    description = "The ip address of the EC2 instance hosting WordPress"
    value = "${module.wordpress.ec2_ip}"
}

output  "rds_host" {
    description = "The hostname of the RDS instance."
    value = "${module.wordpress.rds_host}"
}

output "terraform_state" {
  description = "This output is used as an attribute in the state_file control"

  value = <<EOV
${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate
EOV
}