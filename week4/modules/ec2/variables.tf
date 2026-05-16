variable "ami_id" {
    description = "ami id for the bastion host"
    type = string
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
}

variable "public_subnet_id" {
  description = "public subnet id where bastion host will be launched"
  type = string
}

variable "key_name" {
    description = "Name of the SSH key pair"
    type =string
}

variable "vpc_id" {
    description = "VPC ID for the security group"
    type=string
}

variable "env" {
    description = "Environment type e.g., Dev, Prod"
    type = string
}