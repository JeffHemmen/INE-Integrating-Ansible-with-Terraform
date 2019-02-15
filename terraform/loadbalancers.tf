resource "aws_lb" "wiki-alb" {
  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.wiki-alb-sg.id}"]
  subnets            = ["${aws_subnet.wiki-web-subnet-az1.id}", "${aws_subnet.wiki-web-subnet-az2.id}"]

}

resource "aws_lb_listener" "wiki-alb-listener" {
  load_balancer_arn = "${aws_lb.wiki-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.wiki-alb-trg.arn}"
  }
}

resource "aws_lb_target_group" "wiki-alb-trg" {
  name     = "wiki-lb-trg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.wiki-vpc.id}"
}

resource "aws_lb_target_group_attachment" "wiki-alb-trg-attach" {
  target_group_arn = "${aws_lb_target_group.wiki-alb-trg.arn}"
  target_id        = "${aws_instance.wiki-web-01.id}"
  port             = 80
}

resource "aws_ssm_parameter" "wiki-public-url" {
  name  = "wiki-public-url"
  type  = "String"
  value = "${aws_lb.wiki-alb.dns_name}"
}
