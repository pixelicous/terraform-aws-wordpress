

### Security Groups
resource "aws_security_group" "wordpress_efs" {
  name        = "wordpress_efs"
  vpc_id      = "${aws_vpc.wordpress.id}"
  description = "WordPress EFS"
}
resource "aws_security_group" "wordpress_db" {
  name        = "wordpress_db"
  vpc_id      = "${aws_vpc.wordpress.id}"
  description = "WordPress Database"
}

resource "aws_security_group" "wordpress" {
  name        = "wordpress"
  vpc_id      = "${aws_vpc.wordpress.id}"
  description = "WordPress EC2"
}

resource "aws_security_group" "wordpress_elb" {
  name        = "WordPress ELB"
  vpc_id      = "${aws_vpc.wordpress.id}"
  description = "Control the access to the ELB."
}

# --------------------------------------------------------
### Security group rules

# Any > ELB : HTTP
resource "aws_security_group_rule" "elb_ingress_http" {
  security_group_id = "${aws_security_group.wordpress_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

# Any > ELB : HTTPS
resource "aws_security_group_rule" "elb_ingress_https" {
  security_group_id = "${aws_security_group.wordpress_elb.id}"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

# ELB > EC2 : HTTP
resource "aws_security_group_rule" "elb_egress_http" {
  security_group_id = "${aws_security_group.wordpress_elb.id}"
  source_security_group_id       = "${aws_security_group.wordpress.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

# ELB > EC2 : HTTPS
resource "aws_security_group_rule" "elb_egress_https" {
  security_group_id = "${aws_security_group.wordpress_elb.id}"
  source_security_group_id       = "${aws_security_group.wordpress.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

# EC2 < JumpBox : SSH
resource "aws_security_group_rule" "ingress_ssh" {
  security_group_id = "${aws_security_group.wordpress.id}"
  type              = "ingress"
  cidr_blocks       = ["${var.jumpbox_ip}/32"]
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
}

# EC2 < ELB : HTTP
resource "aws_security_group_rule" "ec2_ingress_http" {
  security_group_id = "${aws_security_group.wordpress.id}"
  type              = "ingress"
  source_security_group_id       = "${aws_security_group.wordpress_elb.id}"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

# EC2 < ELB : HTTPS
resource "aws_security_group_rule" "ec2_ingress_https" {
  security_group_id = "${aws_security_group.wordpress.id}"
  type              = "ingress"
  source_security_group_id       = "${aws_security_group.wordpress_elb.id}"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
}

# EC2 > Any : Ephemeral
resource "aws_security_group_rule" "ec2_egress_reply" {
  security_group_id = "${aws_security_group.wordpress.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}

# --------------------------------------------------------
# EFS

# EFS > Internet : Ephemeral
resource "aws_security_group_rule" "efs_egress_reply" {
  security_group_id = "${aws_security_group.wordpress_efs.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}

# EFS < EC2 : MySQL
resource "aws_security_group_rule" "efs_ingress_mysql" {
  security_group_id = "${aws_security_group.wordpress_efs.id}"
  type              = "ingress"
  cidr_blocks       = ["${aws_instance.wordpress.private_ip}/32"]
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
}

# --------------------------------------------------------
# RDS

# RDS < EC2 : MySQL
resource "aws_security_group_rule" "rds_ingress_mysql" {
  security_group_id = "${aws_security_group.wordpress_db.id}"
  type              = "ingress"
  cidr_blocks       = ["${aws_instance.wordpress.private_ip}/32"]
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
}

# RDS > Any : MySQL
resource "aws_security_group_rule" "rds_egress_mysql" {
  security_group_id = "${aws_security_group.wordpress_db.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 1024
  to_port           = 65535
}
