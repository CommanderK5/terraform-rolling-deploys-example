provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.155.0.0/16"
}

resource "aws_internet_gateway" "example" {
  vpc_id = "${aws_vpc.example.id}"
}

resource "aws_route_table" "example" {
  vpc_id = "${aws_vpc.example.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.example.id}"
  }
}

resource "aws_security_group" "example" {
  name        = "example_sg_allow_all"
  description = "example_sg_allow_all"
  vpc_id      = "${aws_vpc.example.id}"

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["${aws_subnet.example.cidr_block}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table_association" "example" {
    subnet_id      = "${aws_subnet.example.id}"
    route_table_id = "${aws_route_table.example.id}"
}

resource "aws_subnet" "example" {
    vpc_id                  = "${aws_vpc.example.id}"
    cidr_block              = "10.155.0.0/24"
    availability_zone       = "eu-central-1a"
    map_public_ip_on_launch = true
}

