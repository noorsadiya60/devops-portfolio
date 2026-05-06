variable "instance_type" {
    type= string
    default = "t3.micro"
    description = "type of ec2 instance"
  
}

variable "region" {
    type= string
    default = "ap-south-1"
    description = "region in which ec2 instance can get deployed"
}

variable "env" {
   type= string
   default = "dev"
   description = "type of environment where app is going to get deployed"
}