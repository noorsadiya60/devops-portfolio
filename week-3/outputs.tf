output "ec2_public_ip" {
    value= aws_instance.ec2_vmnew.public_ip
    description = "ip of ec2 instance created"
  
}