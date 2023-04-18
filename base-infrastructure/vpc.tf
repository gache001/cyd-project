#VPC in 2 AZs with 4 subnets (2 public, 2 private)
resource "aws_vpc" "cyd" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.common_prefix}-vpc"
  }
}
resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.cyd.id
  cidr_block = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.common_prefix}-public-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}
resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.cyd.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.common_prefix}-public-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_internet_gateway" "cyd" {
  vpc_id = aws_vpc.cyd.id
  tags = {
    Name = "${local.common_prefix}-igw"
  }
}
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.cyd.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.cyd.id
    }
    tags = {
        Name = "${local.common_prefix}-public-rt"
    }
}
resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "nat_1" {
  vpc_id     = aws_vpc.cyd.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${local.common_prefix}-nat-subnet-${data.aws_availability_zones.available.names[0]}"
  }
}
resource "aws_subnet" "nat_2" {
  vpc_id     = aws_vpc.cyd.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${local.common_prefix}-nat-subnet-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_eip" "nat_gw_eip_1" {
  vpc = true
}
resource "aws_eip" "nat_gw_eip_2" {
  vpc = true
}

resource "aws_nat_gateway" "gw_1" {
  allocation_id = aws_eip.nat_gw_eip_1.id
  subnet_id     = aws_subnet.public_1.id
}
resource "aws_nat_gateway" "gw_2" {
  allocation_id = aws_eip.nat_gw_eip_2.id
  subnet_id     = aws_subnet.public_2.id
}

resource "aws_route_table" "nat_1" {
    vpc_id = aws_vpc.cyd.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw_1.id
    }
    tags = {
        Name = "${local.common_prefix}-nat-rt-1"
    }
}
resource "aws_route_table" "nat_2" {
    vpc_id = aws_vpc.cyd.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw_2.id
    }
    tags = {
        Name = "${local.common_prefix}-nat-rt-2"
    }
}

resource "aws_route_table_association" "nat_1" {
    subnet_id = aws_subnet.nat_1.id
    route_table_id = aws_route_table.nat_1.id
}
resource "aws_route_table_association" "nat_2" {
    subnet_id = aws_subnet.nat_2.id
    route_table_id = aws_route_table.nat_2.id
}