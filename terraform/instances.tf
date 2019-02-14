resource "aws_key_pair" "bootstrap" {
  key_name   = "jeff@JEFFS-THINKPAD"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "tls_private_key" "ansible" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "template_file" "user-data-mgt-host" {
  template = "${file("user_data/mgt_host.tpl")}"
}

resource "aws_instance" "wiki-mgt-01" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t3.micro"

  key_name = "${aws_key_pair.bootstrap.key_name}"

  vpc_security_group_ids = ["${aws_security_group.wiki-mgt-sg.id}"]

  subnet_id = "${aws_subnet.wiki-mgt-subnet.id}"
  associate_public_ip_address = true

  iam_instance_profile = "${aws_iam_instance_profile.wiki-mgt-instance-profile.name}"

  user_data = "${data.template_file.user-data-mgt-host.rendered}"

  root_block_device {
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name  = "wiki-mgt-01"
    stack = "wiki_mgt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo useradd ansible -s /bin/bash",
      "sudo mkdir -p ~ansible/.ssh",
      "echo \"${tls_private_key.ansible.private_key_pem}\" | sudo tee ~ansible/.ssh/id_rsa > /dev/null",
      "sudo chmod 400 ~ansible/.ssh/id_rsa",
      "sudo chown -R ansible: ~ansible",
      "echo Done."
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

}


data "template_file" "user-data-ansible-target" {
  template = "${file("user_data/ansible_target.tpl")}"
  vars {
    ansible_public_key = "${tls_private_key.ansible.public_key_openssh}"
  }
}

resource "aws_instance" "wiki-web-01" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t3.micro"

  key_name = "${aws_key_pair.bootstrap.key_name}"

  vpc_security_group_ids = ["${aws_security_group.wiki-web-sg.id}"]

  subnet_id = "${aws_subnet.wiki-web-subnet-az1.id}"
  associate_public_ip_address = false

  user_data = "${data.template_file.user-data-ansible-target.rendered}"

  root_block_device {
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name  = "wiki-web-01"
    stack = "wiki_web"
  }
}
