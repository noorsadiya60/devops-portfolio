variable "public_subnet_id" {
  description = "Public subnet ID from VPC module"
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from VPC module"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID from VPC module"
  type = string
}
variable "env" {
    description = "Environment name"
    type = string
}

variable "region" {
    description = "AWS region"
    type = string
}
