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
resource "aws_instance" "yarden-ec2-1" {

  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.one.id
  associate_public_ip_address = true
  user_data                   = "${file("dockerscript.sh")}"
  # for_each = var.ec2
  tags = {
    # Name = each.value
  }
}
resource "aws_instance" "yarden-ec2-2" {

  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.two.id
  associate_public_ip_address = true
  user_data                   = "${file("dockerscript.sh")}"
  
  tags = {
    Name = "yarden-from-tf2"
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
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "yarden VPC"
  }
}
resource "aws_subnet" "one" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "one"
  }
}
resource "aws_subnet" "two" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "two"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.one.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.two.id
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