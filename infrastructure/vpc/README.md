# AWS VPC Module

Creates a VPC and at least 1 public and 1 private subnet inc. IGW, NAT and required route tables

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
| env | The environment | `string` | `"dev"` | no |
| name | The name of this project | `string` | n/a | yes |
| private\_subnets | A list of private subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| public\_subnets | A list of public subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| vpc\_cidr | The CIDR range for your VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnets | n/a |
| public\_subnets | n/a |
| vpc\_id | n/a |

Philips-MBP-2:vpc philipnichol$ terraform-docs markdown . --sort-by-required
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
| name | The name of this project | `string` | n/a | yes |
| private\_subnets | A list of private subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| public\_subnets | A list of public subnets to create | <pre>list(object({<br>    cidr_block        = string<br>    availability_zone = string<br>  }))</pre> | n/a | yes |
| vpc\_cidr | The CIDR range for your VPC | `string` | n/a | yes |
| env | The environment | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_subnets | n/a |
| public\_subnets | n/a |
| vpc\_id | n/a |

## Usage

```shell
module "vpc" {
  source          = "./vpc"
  name            = var.name
  env             = var.env
  vpc_cidr        = "10.0.0.0/16"
  public_subnets = [
    {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "eu-west-1a"
    },
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "eu-west-1b"
    }
  ]

  private_subnets = [
    {
      cidr_block        = "10.0.100.0/24"
      availability_zone = "eu-west-1a"
    },
    {
      cidr_block        = "10.0.101.0/24"
      availability_zone = "eu-west-1b"
    }
  ]
}
```