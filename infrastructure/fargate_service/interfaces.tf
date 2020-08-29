variable "name" {
  type        = string
  description = "The name of this project"
}

variable "env" {
  type        = string
  description = "The environment"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "cpu" {
  type        = number
  description = "CPU"
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory"
  default     = 512
}

variable "container_port" {
  type        = number
  description = "The port the container listens on"
  default     = 5000
}

variable "desired_count" {
  type        = number
  description = "How many containers to deploy"
  default     = 3
}

variable "target_group_arn" {
  type        = string
  description = "Target group arn"
}

variable "ecs_sgs_id" {
  type        = list(string)
  description = "ECS security group id"
}

variable "ecs_subnet_ids" {
  type        = list(string)
  description = "ECS subnet ids"
}

variable "repo_url" {
  type        = string
  description = "ECR repo"
}

variable "image_name" {
  type        = string
  description = "container image name"
}

variable "image_tag" {
  type        = string
  description = "container image tag"
  default     = "latest"
}

variable "greeting" {
  type        = string
  description = "The greeting for your hello world app"
  default     = "Hello CTM!"
}

variable "time_format" {
  type        = string
  description = "The timeformat ou want displayed"
  default     = "%d/%m/%Y, %H:%M:%S"
}

variable "cluster_id" {
  type        = string
  description = "The ECS cluster ID, leave blank to create one"
  default     = null
}
