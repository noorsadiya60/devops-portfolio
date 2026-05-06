Week 3 — Terraform Language Foundations
Phase: 2 | Course: Terraform-EKS Modules 3–5
What I Built

Wrote main.tf, variables.tf, outputs.tf, backend.tf from scratch — no copy-paste
Provisioned EC2 t3.micro + Security Group on AWS (ap-south-1) using Terraform
Used input variables for instance_type, region, env — no hardcoded values
Tagged resources dynamically using string interpolation (week3-ec2-${var.env})
Configured S3 remote state with DynamoDB locking for team-safe state management
Migrated local state to S3 using terraform init -migrate-state
Deliberately introduced drift by manually deleting EC2 from console — observed Terraform detect and reconcile it

Project Structure
terraform-foundations/
├── main.tf          # EC2 + Security Group resources
├── variables.tf     # instance_type, region, env
├── outputs.tf       # public IP output
└── backend.tf       # S3 remote state + DynamoDB locking
Key Concepts Learned

terraform init → validate → plan → apply → destroy lifecycle
State file — Terraform's source of truth mapping config to real AWS resource IDs
Drift — what happens when infrastructure is changed outside Terraform, and how to fix it
Remote state — why local state breaks in teams, how S3 + DynamoDB solves it
Implicit dependencies — Terraform auto-orders resource creation/destruction from references
vpc_security_group_ids vs security_groups — always use IDs in VPC environments

Mistakes Made & Fixed

Used aws_securitygroup instead of aws_security_group — exact resource type names matter
Forgot ami on aws_instance — required argument, no default
Missing .id on SG reference — resource reference vs attribute reference
Variables declared but not used — added tags block to consume var.env

Definition of Done

✅ EC2 created and destroyed via Terraform
✅ Remote state in S3, lock in DynamoDB
✅ Drift detected and reconciled