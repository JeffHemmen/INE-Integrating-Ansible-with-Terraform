resource "aws_security_group" "wiki-mgt-sg" {
  name        = "wiki-mgt-sg"
  description = "Allow inbound SSH from anywhere"
  vpc_id      = "${aws_vpc.wiki-vpc.id}"

  ingress {
    protocol    = "TCP"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "wiki-alb-sg" {
  name        = "wiki-alb-sg"
  description = "Allow HTTP(S) from the internet"
  vpc_id      = "${aws_vpc.wiki-vpc.id}"

  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wiki-web-sg" {
  name        = "wiki-web-sg"
  description = "Allow inbound HTTP from ALBs"
  vpc_id      = "${aws_vpc.wiki-vpc.id}"

  ingress {
    protocol        = "TCP"
    from_port       = 80
    to_port         = 80
    security_groups = ["${aws_security_group.wiki-alb-sg.id}"]
  }

  ingress {
    protocol        = "TCP"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.wiki-mgt-sg.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "wiki-db-sg" {
  name        = "wiki-db-sg"
  description = "Allow inbound MySQL from web- and mgt-server(s)"
  vpc_id      = "${aws_vpc.wiki-vpc.id}"

  ingress {
    protocol    = "TCP"
    from_port   = 3306
    to_port     = 3306
    security_groups = ["${aws_security_group.wiki-web-sg.id}", "${aws_security_group.wiki-mgt-sg.id}"]
  }
}
