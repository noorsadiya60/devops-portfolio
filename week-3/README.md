# Week 3 — Terraform Language Foundations

**Author:** Noor Sadiya | **Phase:** 2 | **Dates:** May 6–12, 2025

---

## Overview

Provisioned an EC2 t3.micro + Security Group on AWS (`ap-south-1`) using Terraform — built from scratch with modular file structure, input variables, remote state in S3 with DynamoDB locking, and hands-on drift detection and reconciliation.

**Stack:** Terraform 1.6+ · AWS EC2 · S3 · DynamoDB · ap-south-1

---

## Project Structure

```
terraform-foundations/
├── main.tf           # Provider + EC2 + Security Group
├── variables.tf      # instance_type, region, env
├── outputs.tf        # ec2_public_ip
└── backend.tf        # S3 remote state + DynamoDB locking
```

---

## Key Concepts

**Remote State** — State stored in S3 so all team members share the same source of truth. DynamoDB prevents corruption by locking state during `apply` — a second engineer running simultaneously gets a lock error until the first completes.

**Implicit Dependencies** — Referencing `aws_security_group.sg.id` inside `aws_instance` tells Terraform to create the SG first and destroy it last. No `depends_on` needed.

**Drift** — When infrastructure is changed outside Terraform (e.g. manual console delete), `terraform plan` detects the mismatch by calling the AWS API and plans to reconcile. `terraform apply` fixes it.

**Variables vs Locals** — Variables are inputs from outside the module (CLI, tfvars, CI). Locals are internal computed values that don't cross the module boundary.

---

## Definition of Done

- [x] EC2 + SG created and destroyed via Terraform — zero manual clicks
- [x] Remote state verified in S3 with DynamoDB locking configured
- [x] State migrated from local to S3 via `terraform init -migrate-state`
- [x] Drift introduced manually, detected by `plan`, reconciled by `apply`
- [x] Every line written from scratch — no copy-paste from course
- [x] Can explain state, provider blocks, plan output, and drift without notes
