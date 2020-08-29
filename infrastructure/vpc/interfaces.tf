variable "name" {
  type        = string
  description = "The name of this project"
}

variable "env" {
  type        = string
  description = "The environment"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR range for your VPC"
}

variable "public_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "A list of public subnets to create"
}

variable "private_subnets" {
  type = list(object({
    cidr_block        = string
    availability_zone = string
  }))
  description = "A list of private subnets to create"
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [for v in aws_subnet.public : v.id]
}

output "private_subnets" {
  value = [for v in aws_subnet.private : v.id]
}