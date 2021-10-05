resource "aws_vpc" "petclinic" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "petclinic-vpc"
  }
}

resource "aws_internet_gateway" "petclinic-igw" {
  vpc_id = aws_vpc.petclinic.id

  tags = {
    Name = "petclinic-igw"
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.petclinic-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.petclinic-igw.id
}

resource "aws_subnet" "subnet_build" {
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.petclinic.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "subnet-build"
  }
}

resource "aws_subnet" "subnet_web" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.petclinic.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "subnet_web"
  }
}

resource "aws_route_table" "petclinic-rt" {
  vpc_id = aws_vpc.petclinic.id

  tags = {
    Name = "petclinic-rt"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_build.id
  route_table_id = aws_route_table.petclinic-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_web.id
  route_table_id = aws_route_table.petclinic-rt.id
}