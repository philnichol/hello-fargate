resource "aws_ecr_repository" "ecr" {
  name                 = "${var.name}-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "allow_fargate" {
  repository = aws_ecr_repository.ecr.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPull",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${module.fargate.task_exec_role}",
                    "${module.fargate.task_role}"
                ]
            },
            "Action": [
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:DescribeRepositories",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ]
        }
    ]
}
EOF
}