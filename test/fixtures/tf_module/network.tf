### Routing resources
resource "aws_internet_gateway" "wordpress" {
  vpc_id = "${aws_vpc.wordpress.id}"
}

resource "aws_route_table" "wordpress" {
  vpc_id = "${aws_vpc.wordpress.id}"

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
}

resource "aws_subnet" "wordpress_2" {
  vpc_id     = "${aws_vpc.wordpress.id}"
  cidr_block = "192.168.1.0/24"
  availability_zone = "us-east-1a"
}
