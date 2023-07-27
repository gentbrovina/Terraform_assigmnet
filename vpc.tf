
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"   
  tags = {
    Name = "Gent_VPC"    
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"  
  availability_zone       = "us-east-1a"    
}
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24"   
  availability_zone       = "us-east-1b"   
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "Gent_Internet_Gateway"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id   
  subnet_id     = aws_subnet.private_subnet.id
  tags = {
    "Name" = "Gent_Nat_Gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id   
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

data "aws_subnet" "public_subnet" {
  filter {
    name = "tag:Name"
    values = ["Subnet-Public : Public Subnet 1"]
  }

  depends_on = [
    aws_route_table_association.public_subnet_asso
  ]
}
