variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type = string
}

variable "private_subnet_cidr_1" {
    description = "CIDR block for the private subnet 1"
    type = string
}

variable "private_subnet_cidr_2" {
    description = "CIDR block for the private subnet 2"
    type = string
}

variable "env" {
    description = "Environment name e.g., prod, dev"
    type = string
}

variable "region" {
    description = "AWS region"
    type = string
}