provider "aws" {
  region = var.provider_region
  default_tags {
    tags = {
      Owner           = "yarden"
      expiration_date = "30-02-23"
      bootcamp        = "int"
    }
  }
}
terraform {
  backend "s3"{
    bucket = "yarden-s3"
    key = "tfclass"
    region = "eu-west-1"
  }
}
resource "aws_instance" "yarden-ec2" {

  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.subnets, count.index).id
  associate_public_ip_address = true
  user_data                   = "${file("dockerscript.sh")}"
  count = var.ec2
  tags = {
    Name = "yarden-tf-${count.index +1}"
  }
}

resource "aws_security_group" "ec2-sg" {
  name   = "yarden-ec2-SG"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "ssh to ec2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "connect to lb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
   egress  {
    description     = "connect to lb"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "yarden-ec2-SG-tf"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "yarden VPC"
  }
}
resource "aws_subnet" "subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index +1}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "subnet ${count.index +1}"
  }
}

resource "aws_route_table_association" "rta" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id      =  element(aws_subnet.subnets, count.index).id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GW.id
  }
  tags = {
    Name = "yarden-route"
  }
}
resource "aws_internet_gateway" "GW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "yarden-GW"
  }
}