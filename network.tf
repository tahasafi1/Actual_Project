##VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}


##SUBNETS
resource "aws_subnet" "public_subnet" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "pbsub-${each.key}"
  }
}


resource "aws_subnet" "private_subnet" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = "prsub-${each.key}"
  }
}


##GATEWAYS
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-internet-gw"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public_subnet[each.key].id
  allocation_id = aws_eip.nat[each.key].id

  tags = {
    Name = "${var.prefix}-nat-gw"
  }
}

resource "aws_eip" "nat" {
  for_each = var.public_subnets
  domain   = "vpc"
}

##ROUTING
#public
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  tags = {
    Name = "${var.prefix}-public-route-table"
  }
}

resource "aws_route_table_association" "route-table-association" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public_routetable.id
}

#private nat
resource "aws_route_table" "private-nat-routetable" {
  for_each = aws_nat_gateway.nat-gw
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[each.key].id
  }
  tags = {
    Name = "${var.prefix}-private-nat-routetable"
  }
}
resource "aws_route_table_association" "private-routetable-assoc" {
  for_each       = var.private-nat-routetable-assoc
  subnet_id      = aws_subnet.private_subnet[each.value.subnet_id].id
  route_table_id = aws_route_table.private-nat-routetable[each.value.route_table_id].id
}
