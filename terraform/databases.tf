resource "random_string" "wiki-db-password" {
  length = 16
}

resource "aws_db_instance" "wiki-db" {
  name                   = "wiki_db"
  identifier             = "wiki-db"
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  username               = "wikiadmin"
  password               = "${random_string.wiki-db-password.result}"
  db_subnet_group_name   = "${aws_db_subnet_group.wiki-db-subnet-group.name}"
  vpc_security_group_ids = ["${aws_security_group.wiki-db-sg.id}"]

  skip_final_snapshot  = true

  tags = {
    stack = "wiki_db"
  }
}

resource "aws_ssm_parameter" "wiki-db-password" {
  name  = "wiki-db-password"
  type  = "SecureString"
  value = "${random_string.wiki-db-password.result}"
}
