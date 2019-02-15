resource "null_resource" "run-ansible" {

  triggers {
    cluster_instance_ids = "${aws_instance.wiki-mgt-01.id}, ${aws_instance.wiki-web-01.id}, ${aws_db_instance.wiki-db.id}"
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      host        = "${aws_instance.wiki-mgt-01.public_ip}"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "sudo su ansible -c 'cd ~ansible && git clone https://github.com/JeffHemmen/INE-Integrating-Ansible-with-Terraform.git wiki'",
      "sudo su ansible -c 'cd ~ansible/wiki/ansible && ansible-playbook deploy-wiki-stack.yml'"
    ]
  }


}
