resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.registro-ponto-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.registro-ponto-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.registro-ponto-public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.registro-ponto-private-subnet.id
  route_table_id = aws_route_table.public.id
}
