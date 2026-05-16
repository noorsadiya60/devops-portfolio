output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnet"
  value       = module.vpc.private_subnet_ids
}

output "bastion_public_ip" {
  description = "public ip of bastion host"
  value       = module.ec2.bastion_public_ip
}