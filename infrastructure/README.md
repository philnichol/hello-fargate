# Hello-CTM Infra

This repo houses the infrastructure for Hello-CTM, it mainly consists of:
- 1 VPC
- 4 subnets (2 public, 2 private)
- 1 ALB
- 1 ECR
- 1 ECS cluster with a single service running
- Security groups
- IAM roles
- CloudWatch alerts for >75% CPU and memory, and if there's ever only 1 or less tasks running

## Backend
While testing locally the statefile is stored locally, but for a proper environment it would be stored in S3.

## for_each vs. count
When a loop was required and I felt it appropriate, I went with for_each instead of count.  
This allows the resources to be indexed via a key rather than just their order in a list.  
While more verbose, this means that changing an item in a list won't force a recreation of all other items in the list.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Which environemnt (dev\|uat\|prod) | `any` | n/a | yes |
| image\_tag | the container image tag to use | `any` | n/a | yes |
| name | The name of your project | `any` | n/a | yes |
| private\_subnets | A list of private subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| public\_subnets | A list of public subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| region | The AWS region | `any` | n/a | yes |
| container\_port | The port your container will listen on | `number` | `5000` | no |
