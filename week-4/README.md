# Week 4 — Terraform VPC + Modules

## What I Built

A production-grade 3-tier VPC on AWS using Terraform, structured with reusable modules and remote state.

## Architecture

```
                        Internet
                            │
                          [IGW]
                            │
                 [VPC — 10.0.0.0/16]
                            │
              ┌─────────────┴──────────────┐
      [Public Subnet]              
      10.0.1.0/24 (ap-south-1a)   
      [Bastion Host] [NAT Gateway]
              │
      ┌───────┴────────┐
 [Private Subnet 1]  [Private Subnet 2]
 10.0.2.0/24          10.0.3.0/24
 (ap-south-1b)        (ap-south-1c)
```

## Folder Structure

```
week4/
├── main.tf           # Root module — calls vpc and ec2 modules
├── variables.tf      # Input variables with defaults
├── outputs.tf        # Prints VPC ID, subnet IDs, bastion IP
├── backend.tf        # Remote state — S3 + DynamoDB locking
└── modules/
    ├── vpc/
    │   ├── main.tf       # VPC, subnets, IGW, NAT GW, route tables
    │   ├── variables.tf  # Module inputs
    │   └── outputs.tf    # Exports vpc_id, subnet IDs
    └── ec2/
        ├── main.tf       # Bastion EC2 + security group
        ├── variables.tf  # Module inputs
        └── outputs.tf    # Exports bastion public IP
```