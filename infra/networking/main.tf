variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}

output "webAppVpcId" {
  value = aws_vpc.webAppVpc.id
}

output "publicSubnetCidrBlock" {
  value = aws_subnet.webAppVpcPublicSubnet.*.cidr_block
}

output "webAppPublicSubnetId" {
  value = aws_subnet.webAppVpcPublicSubnet.*.id
}

output "dbPrivateSubnetId" {
  value = aws_subnet.webAppVpcPrivateSubnet.*.id
}

resource "aws_vpc" "webAppVpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "webAppVpc"
  }
}

resource "aws_subnet" "webAppVpcPublicSubnet" {
  vpc_id = aws_vpc.webAppVpc.id
  count = length(var.cidr_public_subnet)
  cidr_block = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "webAppVpcPublicSubnet-${count.index + 1}"
  }
}

resource "aws_subnet" "webAppVpcPrivateSubnet" {
  vpc_id = aws_vpc.webAppVpc.id
  count = length(var.cidr_private_subnet)
  cidr_block = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name = "webAppVpcPrivateSubnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "webAppInternetGateway" {
  vpc_id = aws_vpc.webAppVpc.id

  tags = {
    Name = "webAppInternetGateway"
  }
}

resource "aws_route_table" "webAppPublicSubnetRouteTable" {
  vpc_id = aws_vpc.webAppVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webAppInternetGateway.id
  }

  tags = {
    Name = "webAppPublicSubnetRouteTable"
  }
}

resource "aws_route_table_association" "webAppPublicSubnetRouteTableAssociation" {
  route_table_id = aws_route_table.webAppPublicSubnetRouteTable.id
  count = length(aws_subnet.webAppVpcPublicSubnet)
  subnet_id = aws_subnet.webAppVpcPublicSubnet[count.index].id
}

resource "aws_route_table" "webAppPrivateSubnetRouteTable" {
  vpc_id = aws_vpc.webAppVpc.id

  tags = {
    Name = "webAppPrivateSubnetRouteTable"
  }
}

resource "aws_route_table_association" "webAppPrivateSubnetRouteTableAssociation" {
  route_table_id = aws_route_table.webAppPrivateSubnetRouteTable.id
  count = length(aws_subnet.webAppVpcPrivateSubnet)
  subnet_id = aws_subnet.webAppVpcPrivateSubnet[count.index].id
}