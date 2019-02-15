### VPC

resource "aws_vpc" "wiki-vpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "wiki-vpc"
  }
}

resource "aws_internet_gateway" "wiki-vpc-gw" {
  vpc_id = "${aws_vpc.wiki-vpc.id}"
  tags {
    Name = "wiki-web-mgt-gw"
  }
}



### MANAGEMENT Network

resource "aws_subnet" "wiki-mgt-subnet" {
  vpc_id     = "${aws_vpc.wiki-vpc.id}"
  cidr_block = "10.0.0.0/24"
  tags {
    Name = "wiki-mgt-subnet"
  }
}

resource "aws_route" "wiki-mgt-subnet-internet" {
  route_table_id         = "${aws_vpc.wiki-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.wiki-vpc-gw.id}"
}



### WEBSERVER Networking

data "aws_availability_zones" "available" {}

resource "aws_subnet" "wiki-web-subnet-az1" {
  vpc_id     = "${aws_vpc.wiki-vpc.id}"
  cidr_block = "10.0.10.0/25"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
    Name = "wiki-web-subnet-az1"
  }
}

resource "aws_subnet" "wiki-web-subnet-az2" {
  vpc_id     = "${aws_vpc.wiki-vpc.id}"
  cidr_block = "10.0.10.128/25"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    Name = "wiki-web-subnet-az2"
  }
}


### DATABASE Networking

resource "aws_subnet" "wiki-db-subnet-az1" {
  vpc_id     = "${aws_vpc.wiki-vpc.id}"
  cidr_block = "10.0.20.0/25"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
    Name = "wiki-db-subnet-az1"
  }
}

resource "aws_subnet" "wiki-db-subnet-az2" {
  vpc_id     = "${aws_vpc.wiki-vpc.id}"
  cidr_block = "10.0.20.128/25"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  tags {
    Name = "wiki-db-subnet-az2"
  }
}

resource "aws_db_subnet_group" "wiki-db-subnet-group" {
  name       = "wiki-db-subnet-group"
  subnet_ids = ["${aws_subnet.wiki-db-subnet-az1.id}", "${aws_subnet.wiki-db-subnet-az2.id}"]
}
