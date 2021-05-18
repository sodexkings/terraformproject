variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "vpc_prod"
}

variable "public_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_name" {
  default = "public_prod"
}

variable "private_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_name" {
  default = "private_prod"
}


variable "igw_name" {
  default = "igw_prod"
}


variable "routable_name" {
  default = "routable_prod"
}

variable "securitygroup_name" {
  default = "sg_ssh"
}

variable "instance_name" {
  default = "jboss_server"
}


