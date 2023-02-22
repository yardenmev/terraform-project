variable "key_name" {
  type    = string
  default = "int-devops-bootcamp"
}

variable "instance_type" {
  type    = string
  default = "t3a.micro"
}

variable "ami" {
  type    = string
  default = "ami-06d94a781b544c133"
}

variable "provider_region" {
  type    = string
  default = "eu-west-1"
}

variable "ec2" {
  type    = list(string)
  default = ["yar1", "yar2"]
}




