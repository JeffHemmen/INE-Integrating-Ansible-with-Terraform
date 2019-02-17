resource "null_resource" "run-ansible" {

  triggers {
    cluster_instance_ids = "${aws_instance.wiki-mgt-01.id}, ${aws_instance.wiki-web-01.id}, ${aws_db_instance.wiki-db.id}"
  }

  provisioner "file" {

    connection {
      type        = "ssh"
      host        = "${aws_instance.wiki-mgt-01.public_ip}"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    source      = "../ansible"  # IMPORTANT: No trailing slash.
    destination = "/tmp"
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      host        = "${aws_instance.wiki-mgt-01.public_ip}"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }

    inline = [
      "sudo mv /tmp/ansible ~ansible/wiki",
      "sudo chown -R ansible: ~ansible/",
      "sudo chmod +x ~ansible/wiki/inventory/ec2.py",
      "sudo su ansible -c 'cd ~ansible/wiki/ && ansible-playbook deploy-wiki-stack.yml'"
    ]
  }


}
