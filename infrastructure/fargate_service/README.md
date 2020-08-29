# AWS Fargate

This module deploys a fargate service.  
Sensible defaults are set assuming you're creating a hello world Flask container

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ecs\_sgs\_id | ECS security group id | `list(string)` | n/a | yes |
| ecs\_subnet\_ids | ECS subnet ids | `list(string)` | n/a | yes |
| name | The name of this project | `string` | n/a | yes |
| repo\_url | ECR repo | `string` | n/a | yes |
| target\_group\_arn | Target group arn | `string` | n/a | yes |
| cluster\_id | The ECS cluster ID, leave blank to create one | `string` | `null` | no |
| container\_port | The port the container listens on | `number` | `5000` | no |
| cpu | CPU | `number` | `256` | no |
| desired\_count | How many containers to deploy | `number` | `3` | no |
| env | The environment | `string` | `"dev"` | no |
| greeting | The greeting for your hello world app | `string` | `"Hello CTM!"` | no |
| healthcheck\_command | container healthcheck command, defaults to flask command on port 5000 which requires curl | `string` | `"curl -s -k -o /dev/null --write-out %{http_code} 127.0.0.1:5000 | grep 200 || exit 1"` | no |
| image\_tag | container image tag | `string` | `"latest"` | no |
| memory | Memory | `number` | `512` | no |
| region | AWS region | `string` | `"eu-west-1"` | no |
| time\_format | The timeformat ou want displayed | `string` | `"%d/%m/%Y, %H:%M:%S"` | no |

## Outputs

| Name | Description |
|------|-------------|
| task\_exec\_role | n/a |
| task\_role | n/a |

## Usage

```shell
module "fargate" {
  source           = "./fargate_service"
  name             = var.name
  env              = var.env
  target_group_arn = aws_alb_target_group.main.arn
  ecs_sgs_id       = [aws_security_group.ecs.id]
  ecs_subnet_ids   = module.vpc.private_subnets
  repo_url         = aws_ecr_repository.ecr.repository_url
  image_tag        = var.image_tag
}
```