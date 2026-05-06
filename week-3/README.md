Week 3 — Terraform Language Foundations
Phase: 2 | Course: Terraform-EKS Modules 3–5
What I Built

1. Wrote main.tf, variables.tf, outputs.tf, backend.tf from scratch
2. Provisioned EC2 t3.micro + Security Group on AWS (ap-south-1) using Terraform
3. Used input variables for instance_type, region, env — no hardcoded values
4. Tagged resources dynamically using string interpolation (week3-ec2-${var.env})
5. Configured S3 remote state with DynamoDB locking for team-safe state management
6. Migrated local state to S3 using terraform init -migrate-state
7. Deliberately introduced drift by manually deleting EC2 from console — observed Terraform detect and reconcile it
