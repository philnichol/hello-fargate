variable "name" {
}

variable "env" {

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
  default = 5000
}