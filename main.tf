resource "aws_vpc" "vpc01" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_subnet" "public01" {
  vpc_id     = aws_vpc.vpc01.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_name
  }
}

resource "aws_subnet" "private01" {
  vpc_id     = aws_vpc.vpc01.id
  cidr_block = var.private_cidr

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.vpc01.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "routable01" {
  vpc_id = aws_vpc.vpc01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw01.id
  }

  tags = {
    Name = var.routable_name
  }
}


resource "aws_route_table_association" "association1" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.routable01.id
}


resource "aws_route_table_association" "association2" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.routable01.id
}




resource "aws_security_group" "sg01" {
  name        = "sg_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc01.id


  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.securitygroup_name
  }
}


resource "aws_instance" "uat-publicserver1" {
  ami           = "ami-06c6dd3519b4e4f79"
  instance_type = "t2.micro"
  key_name = "mykpair_01"
  security_groups = [aws_security_group.sg01.id]
  subnet_id = aws_subnet.public01.id
  provisioner "local-exec" {
    command = "echo ${aws_instance.uat-publicserver1.public_ip} > inventory"
  }

 tags = {
    Name = var.instance_name
  }
}


