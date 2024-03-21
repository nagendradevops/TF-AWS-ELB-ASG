#Creating VPC - with Resource block
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "myvpc"
  }
}

#By using multiprovider can create VPC
/*resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"
  provider = aws.aws-west-1     #By using multiprovider purpose
  tags = {
    "Name" = "myvpc"
  }
} */

#Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

#create Internet Gateway
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

}

#Create public routetable
resource "aws_route_table" "mypubrtable" {
  vpc_id = aws_vpc.myvpc.id
}

#create route in routetable for internet access
resource "aws_route" "mypublicrt" {
  route_table_id         = aws_route_table.mypubrtable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myigw.id

}

#Associate teh routetable with subnet
resource "aws_route_table_association" "myrtassociate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.mypubrtable.id

}

#create security group
resource "aws_security_group" "mysecgrp" {
  name        = "mysecgrp"
  description = "Dev VPC Sec Group"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }


  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Allow all IP and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }

}

#Create EIP
resource "aws_eip" "myeip" {
  #instance = aws_instance.my-ec2.id
  # Meta-Argument
  depends_on = [aws_internet_gateway.myigw]

}