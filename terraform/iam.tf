### Instance Profile: attaches role to EC2 instance

resource "aws_iam_instance_profile" "wiki-mgt-instance-profile" {
  name        = "wiki-mgt-instance-profile"
  path        = "/"
  role        = "${aws_iam_role.wiki-mgt-iam-role.name}"
}

### IAM Role: Defines who can assume the role, and is referenced by one or more policies

resource "aws_iam_role" "wiki-mgt-iam-role" {
  name                  = "wiki-mgt-iam-role"
  path                  = "/wiki/"
  assume_role_policy    = "${data.aws_iam_policy_document.wiki-mgt-iam-role-assume-role-policy-data.json}"
  description           = "Allows EC2 instances to call AWS services on your behalf."
}

data "aws_iam_policy_document" "wiki-mgt-iam-role-assume-role-policy-data" {
  version = "2012-10-17"
  statement {
    effect     = "Allow"
    actions    = ["sts:AssumeRole"]
    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

### IAM Role Policy: is attached to a role; defines which access to which resources is allowed/denied

# query-ssm-for-db-pass
resource "aws_iam_role_policy" "wiki-mgt-query-ssm-for-db-pass-policy" {
  name        = "wiki-mgt-query-ssm-for-db-pass-policy"
  role        = "${aws_iam_role.wiki-mgt-iam-role.id}"
  policy      = "${data.aws_iam_policy_document.wiki-mgt-query-ssm-for-db-pass-policy-data.json}"
}

data "aws_iam_policy_document" "wiki-mgt-query-ssm-for-db-pass-policy-data" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["${aws_ssm_parameter.wiki-db-password.arn}"]
  }
}

# list-ec2-instances-for-dynamic-inventory
resource "aws_iam_role_policy" "wiki-mgt-list-ec2-instances-for-dynamic-inventory-policy" {
  name        = "wiki-mgt-list-ec2-instances-for-dynamic-inventory-policy"
  role        = "${aws_iam_role.wiki-mgt-iam-role.id}"
  policy      = "${data.aws_iam_policy_document.wiki-mgt-list-ec2-instances-for-dynamic-inventory-policy-data.json}"
}

data "aws_iam_policy_document" "wiki-mgt-list-ec2-instances-for-dynamic-inventory-policy-data" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances", "ec2:DescribeTags"]
    resources = ["*"]
  }
}

# list-rds-instances-for-dynamic-inventory
resource "aws_iam_role_policy" "wiki-mgt-list-rds-instances-for-dynamic-inventory-policy" {
  name        = "wiki-mgt-list-rds-instances-for-dynamic-inventory-policy"
  role        = "${aws_iam_role.wiki-mgt-iam-role.id}"
  policy      = "${data.aws_iam_policy_document.wiki-mgt-list-rds-instances-for-dynamic-inventory-policy-data.json}"
}

data "aws_iam_policy_document" "wiki-mgt-list-rds-instances-for-dynamic-inventory-policy-data" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeInstances", "ec2:DescribeTags"]
    resources = ["*"]
  }
}
