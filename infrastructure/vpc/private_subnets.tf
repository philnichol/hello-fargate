resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[var.public_subnets[0].cidr_block].id
}

resource "aws_subnet" "private" {
  for_each                = { for subnet in var.private_subnets : subnet.cidr_block => subnet }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  depends_on              = [aws_nat_gateway.nat]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private" {
  for_each       = { for subnet in var.private_subnets : subnet.cidr_block => subnet }
  subnet_id      = aws_subnet.private[each.value.cidr_block].id
  route_table_id = aws_route_table.private.id
}