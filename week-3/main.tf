terraform{
    required_version = ">= 1.6.0"
    required_providers {
      aws={
        source = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
}

provider "aws" {
        region = var.region
        profile = "default"
}

resource "aws_instance" "ec2_vmnew"{
    ami="ami-0f58b397bc5c1f2e8"
    instance_type=var.instance_type
    vpc_security_group_ids = [aws_security_group.sg.id]

    tags = {
      Environment = var.env
      Name="week3-ec2-${var.env}"
    }
}

resource "aws_security_group" "sg" {
    name = "week3-sg"
    description = "parctice week 3 sg"
}