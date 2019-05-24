#--------------------------------------------------------
### EC2

resource "aws_eip" "wordpress" {
  instance = "${aws_instance.wordpress.id}"
  vpc      = false
}

resource "aws_route53_record" "wordpress" { #EC2 public ip a record, used with EFS' dns 
  zone_id = "${var.route53_zone_id}"
  name    = "${var.route53_record_name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.wordpress.public_ip}"]
}

resource "aws_key_pair" "wordpress" {
  key_name = "${var.ec2_key_name}"

  public_key = "${var.key_pair_public_key}"
}

#--------------------------------------------------------
### EC2
resource "aws_instance" "wordpress" {
  ami           = "${lookup(var.ami_images, var.region)}"
  key_name = "${aws_key_pair.wordpress.key_name}"
  instance_type = "${var.ec2_instance_type}"
  subnet_id = "${aws_subnet.wordpress.id}"
  iam_instance_profile = "${aws_iam_instance_profile.wordpress.name}"

  vpc_security_group_ids = [
    "${aws_security_group.wordpress.id}",
  ]

  availability_zone = "${aws_subnet.wordpress.availability_zone}"
  associate_public_ip_address = true

  root_block_device = {
    "volume_type"           = "standard"
    "volume_size"           = 40
    "delete_on_termination" = false
  }

  tags = "${var.tags}"
}

resource "null_resource" "bootstrap_ec2" {
  # EC2 Must be configured externally as the EC2<>RDS security groups 
  # must be created before, for communication

  depends_on = ["aws_security_group_rule.rds_ingress_mysql"]

  triggers = {
    ec2_instances = "${aws_instance.wordpress.private_ip}"
  }

    connection {
      host = "${aws_eip.wordpress.public_ip}"
      type     = "ssh"
      user = "bitnami" # Default username of the AMI
      private_key = "${file("${path.module}/test/assets/${var.ec2_key_name}")}"
    }

  provisioner "file" {
    source      = "${path.module}/ec2-scripts/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh ${local.db_username} ${var.db_password} ${local.db_name} ${aws_db_instance.wordpress.address}",
      "rm /tmp/bootstrap.sh"
    ]
  }
}

