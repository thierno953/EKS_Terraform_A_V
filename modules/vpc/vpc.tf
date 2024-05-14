# Create a VPC
resource "aws_vpc" "tfVPC" {
  instance_tenancy = "default"
  cidr_block       = var.vpc_cidr
  tags             = var.vpc_tags
}

resource "aws_internet_gateway" "tfIGW" {
  vpc_id = aws_vpc.tfVPC.id
  tags = {
    Name    = "tfIGW"
    Project = "TF Project"
  }
}

resource "aws_eip" "tfNatGatewayEIP1" {
  tags = {
    Name    = "tfNatGatewayEIP1"
    Project = "TF Project"
  }
}

resource "aws_nat_gateway" "tfNatGateway1" {
  allocation_id = aws_eip.tfNatGatewayEIP1.id
  subnet_id     = aws_subnet.tfPublicSubnet1.id
  tags = {
    Name    = "tfNatGateway1"
    Project = "TF Project"
  }
}

resource "aws_subnet" "tfPublicSubnet1" {
  vpc_id                  = aws_vpc.tfVPC.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "tfPublicSubnet1"
    Project = "TF Project"
  }
}

resource "aws_eip" "tfNatGatewayEIP2" {
  tags = {
    Name    = "tfNatGatewayEIP2"
    Project = "TF Project"
  }
}

resource "aws_nat_gateway" "tfNatGateway2" {
  allocation_id = aws_eip.tfNatGatewayEIP2.id
  subnet_id     = aws_subnet.tfPublicSubnet1.id
  tags = {
    Name    = "tfNatGateway2"
    Project = "TF Project"
  }
}

resource "aws_subnet" "tfPublicSubnet2" {
  vpc_id                  = aws_vpc.tfVPC.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name    = "tfPublicSubnet2"
    Project = "TF Project"
  }
}

resource "aws_subnet" "tfPrivateSubnet1" {
  vpc_id                  = aws_vpc.tfVPC.id
  cidr_block              = var.private_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "tfPrivateSubnet1"
    Project = "TF Project"
  }
}

resource "aws_subnet" "tfPrivateSubnet2" {
  vpc_id                  = aws_vpc.tfVPC.id
  cidr_block              = var.private_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name    = "tfPrivateSubnet2"
    Project = "TF Project"
  }
}

resource "aws_route_table" "tfPublicRT" {
  vpc_id = aws_vpc.tfVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfIGW.id
  }
  tags = {
    Name    = "tfPublicRT"
    Project = "TF Project"
  }
}

resource "aws_route_table" "tfPrivateRT1" {
  vpc_id = aws_vpc.tfVPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tfNatGateway1.id
  }
  tags = {
    Name    = "tfPrivateRT1"
    Project = "TF Project"
  }
}

resource "aws_route_table_association" "tfPublicRTassociation1" {
  subnet_id      = aws_subnet.tfPublicSubnet1.id
  route_table_id = aws_route_table.tfPublicRT.id
}

resource "aws_route_table_association" "tfPublicRTassociation2" {
  subnet_id      = aws_subnet.tfPublicSubnet2.id
  route_table_id = aws_route_table.tfPublicRT.id
}
