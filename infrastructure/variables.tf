variable "name" {
  description = "The name of your project"
}

variable "env" {
  description = "Which environemnt (dev|uat|prod)"
}

variable "region" {
  description = "The AWS region"
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

variable "container_port" {
  description = "The port your container will listen on"
  default     = 5000
}

variable "image_tag" {
  description = "the container image tag to use"
}