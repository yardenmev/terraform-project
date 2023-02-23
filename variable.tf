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
  default = 6
  type = number
}
# variable "subnets" {
#   default = 3
#   type = number
# }





