resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  for_each                = { for subnet in var.public_subnets : subnet.cidr_block => subnet }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = { for subnet in var.public_subnets : subnet.cidr_block => subnet }
  subnet_id      = aws_subnet.public[each.value.cidr_block].id
  route_table_id = aws_route_table.public.id
}