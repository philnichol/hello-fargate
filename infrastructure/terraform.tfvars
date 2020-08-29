name = "hello-ctm"
env  = "dev"

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