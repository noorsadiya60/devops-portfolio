resource "aws_instance" "bastion" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.public_subnet_id
    key_name = var.key_name
    associate_public_ip_address = true

    vpc_security_group_ids = [aws_security_group.bastion_sg.id]

    tags = {
        Name = "${var.env}-bastion"
    }
}

resource "aws_security_group" "bastion_sg" {
    name = "${var.env}-bastion-sg"
    description = "Allow SSH inbound"
    vpc_id = var.vpc_id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "${var.env}-bastion-sg"
    }
  
}