# INE-Integrating-Ansible-with-Terraform

A sample project to illustrate how Terraform and Ansible can be used together.

This project is a one-click deploy of a small MediaWiki stack (see https://www.mediawiki.org/ ).  
The stack consists of two EC2 instances, one RDS instance, and one ALB (plus ancilliary resources).

The focus is on secrets management, especially passing the database credentials from Terraform to Ansible. Secrets are all generated randomly during deployment, and never transferred unencrypted between Terraform and Ansible.

## Usage
### Prerequisites
* An AWS account;
* a set of `AWS_ACCESS_KEY_ID` & `AWS_SECRET_ACCESS_KEY`;
* enough privileges across `IAM`, `EC2`, `VPC`, `RDS`, and `Systems Manager`.



Simply set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` and run:

 ```shell
 cd terraform/
 terraform apply [-auto-approve]
 ```

 (You can also set your AWS credentials in `terraform/meta.tf` or in `~/.aws/`. See https://www.terraform.io/docs/providers/aws/ for details.)

Terraform will provision all the infrastructure, clone this repository onto the wiki-mgt node, trigger an Ansible run, and finally print the URL of the loadbalancer, e.g.

```
Outputs:

wiki-public-url = wiki-alb-123456789.us-east-1.elb.amazonaws.com
```
You can then navigate to this URL using HTTP.

## Caveats
### Security
This project does not implement a remote state. All secrets will be stored in plaintext in your local Terraform state.

A few secrets are generated and stored on the wiki-mgt host only. These can be changed / regenerated on subsequent Ansible runs, and only need to be consistent throughout a given Ansible run.

### Other
This repository is cloned onto the wiki-mgt host. Its URL is hard-coded (in `terraform/run_ansible.tf`), so beware if you fork this project.

MediaWiki needs to be manually configured and a PHP file uploaded after install. This is not catered for, as this project is a POC only.
