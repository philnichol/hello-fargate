resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_cloudwatch_log_group" "vpc" {
  name = "/aws/vpc/${var.name}-${var.env}-vpc"
}

resource "aws_iam_role" "vpc" {
  name               = "${var.name}-${var.env}-vpc-flow-logs"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "vpc-flow-logs.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_flow_log" "flow" {
  vpc_id          = aws_vpc.vpc.id
  log_destination = aws_cloudwatch_log_group.vpc.arn
  iam_role_arn    = aws_iam_role.vpc.arn
  traffic_type    = "ALL"
}

data "template_file" "vpc_policy" {
  template = file("${path.module}/policies/vpc_flow_logs_template.json")

  vars = {
    log_group_arn = aws_cloudwatch_log_group.vpc.arn
  }
}

resource "aws_iam_role_policy" "flow" {
  name   = "${var.name}-${var.env}-flow-logs"
  policy = data.template_file.vpc_policy.rendered
  role   = aws_iam_role.vpc.id
}

