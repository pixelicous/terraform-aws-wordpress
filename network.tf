### Routing resources
resource "aws_internet_gateway" "wordpress" {
  vpc_id = "${aws_vpc.wordpress.id}"

  tags = "${var.tags}"
}

resource "aws_route_table" "wordpress" {
  vpc_id = "${aws_vpc.wordpress.id}"

  tags = "${var.tags}"
}

resource "aws_route" "route_out" {
  route_table_id            = "${aws_route_table.wordpress.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.wordpress.id}"
}

resource "aws_main_route_table_association" "wordpress" {
  vpc_id         = "${aws_vpc.wordpress.id}"
  route_table_id = "${aws_route_table.wordpress.id}"
}

#--------------------------------------------------------
### VPC & Subnets

resource "aws_vpc" "wordpress" {
  cidr_block = "192.168.0.0/22"
}

resource "aws_subnet" "wordpress" {
  vpc_id     = "${aws_vpc.wordpress.id}"
  cidr_block = "192.168.0.0/24"
  availability_zone = "us-east-1b"

  tags = "${var.tags}"
}

resource "aws_subnet" "wordpress2" {
  vpc_id     = "${aws_vpc.wordpress.id}"
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-1a"

  tags = "${var.tags}"
}

resource "aws_db_subnet_group" "wordpress" {
  name       = "main"
  subnet_ids = ["${aws_subnet.wordpress.id}","${aws_subnet.wordpress2.id}"]

  tags = "${var.tags}"
}
