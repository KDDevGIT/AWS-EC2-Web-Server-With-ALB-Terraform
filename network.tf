resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.this.id 
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project_name}-private-${count.index}"
  }
}

# One NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id 
  tags = {
    Name = "${var.project_name}-nat"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id 
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count = 2
  subnet_id = aws_subnet.public[count.index].id 
  route_table_id = aws_route_table.public.id 
}

# Private Route Table(s)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  count = 2
  subnet_id = aws_subnet.private[count.index].id 
  route_table_id = aws_route_table.private.id 
}


