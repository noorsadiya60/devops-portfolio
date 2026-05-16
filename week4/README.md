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

## Resources Created

| Resource | Details |
|---|---|
| VPC | `10.0.0.0/16`, DNS hostnames enabled |
| Public Subnet | `10.0.1.0/24`, ap-south-1a |
| Private Subnet 1 | `10.0.2.0/24`, ap-south-1b |
| Private Subnet 2 | `10.0.3.0/24`, ap-south-1c |
| Internet Gateway | Attached to VPC |
| NAT Gateway | In public subnet with Elastic IP |
| Route Table (public) | `0.0.0.0/0` → IGW |
| Route Table (private) | `0.0.0.0/0` → NAT Gateway |
| Bastion Host | t3.micro, Amazon Linux 2023, public subnet |
| Security Group | Port 22 inbound, all outbound |

## Key Concepts

**Why spread subnets across AZs?**
High availability — if ap-south-1a goes down, workloads in 1b and 1c keep running.

**NAT Gateway vs Bastion Host**
- NAT Gateway = outbound internet for private EC2s (automated, no humans)
- Bastion Host = inbound SSH access for engineers (jump server)

**Why `lifecycle { prevent_destroy = true }` on VPC?**
Destroying a VPC takes down everything inside it. This acts as a safety net — Terraform will error instead of silently destroying it.

**Why modules?**
Reusability — the same `modules/vpc` can be called from a `dev` root and a `prod` root with different variable values. No code duplication.

## How to Deploy

```bash
# Initialise
terraform init

# Preview
terraform plan -var="key_name=your-key-name"

# Apply
terraform apply -var="key_name=your-key-name"

# SSH into bastion
ssh -i ~/.ssh/your-key.pem -o IdentitiesOnly=yes ec2-user@<bastion_public_ip>

# Destroy (always destroy after practice — NAT Gateway costs money)
terraform destroy -var="key_name=your-key-name"
```

## What Broke and How I Fixed It

**1. Wrong AMI for region**
Used an AMI ID that was invalid for `ap-south-1`. Instance launched but SSH kept failing — the OS wasn't configured correctly. Fixed by fetching the latest Amazon Linux 2023 AMI directly from AWS:
```bash
aws ec2 describe-images \
  --region ap-south-1 \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023*-x86_64" "Name=state,Values=available" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
  --output text
```

**2. SSH key truncation**
RSA private key was getting truncated when saved to `.pem` file due to `.ssh` directory permission issues. Fixed by switching to ED25519 key type which is shorter and saved correctly.

**3. SSH agent interference**
SSH agent was offering a different RSA key before the correct ED25519 key, causing the server to reject the connection. Fixed with `-o IdentitiesOnly=yes` flag.

## Terraform Commands Used

```bash
terraform init              # Download providers, init backend
terraform validate          # Check syntax
terraform fmt               # Auto-format code
terraform plan              # Preview changes
terraform apply             # Create resources
terraform destroy           # Tear down all resources
terraform destroy -target=module.ec2.aws_instance.bastion  # Destroy specific resource
```

## Cost Notes

| Resource | Cost | Action |
|---|---|---|
| NAT Gateway | ~$0.045/hr | Destroy same day |
| EC2 t3.micro | ~$0.013/hr | Destroy same day |
| Elastic IP | Free when attached | Released on destroy |
| S3 remote state | ~$0.02/month | Keep |
| DynamoDB lock table | Free tier | Keep |
