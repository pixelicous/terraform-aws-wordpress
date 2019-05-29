

#--------------------------------------------------------
### VPC & Subnets

data "aws_subnet" "wordpress" {
  id = "${var.subnet_id}"
}

data "aws_subnet" "wordpress_2" {
  id = "${var.subnet_2_id}"
}

resource "aws_db_subnet_group" "wordpress" {
  name       = "main"
  subnet_ids = ["${data.aws_subnet.wordpress.id}","${data.aws_subnet.wordpress_2.id}"]

  tags = "${var.tags}"
}
