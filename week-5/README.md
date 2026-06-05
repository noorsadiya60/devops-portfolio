# Week 5 — EKS Cluster + Kubernetes Fundamentals

> **Noor Sadiya** | Senior SRE Preparation | June 2026 | Region: `ap-south-1`

---

## Architecture Overview

```
                        ┌─────────────────────────────────────────┐
                        │           AWS ap-south-1                 │
                        │                                          │
                        │  ┌─────────────────────────────────┐    │
                        │  │         VPC (10.0.0.0/16)        │    │
                        │  │                                   │    │
  Internet ─── IGW ────►│  │  ┌──────────────────────────┐   │    │
                        │  │  │  Public Subnet 10.0.1.0   │   │    │
                        │  │  │  ┌────────┐ ┌────────┐   │   │    │
                        │  │  │  │ Node 1 │ │ Node 2 │   │   │    │
                        │  │  │  └────────┘ └────────┘   │   │    │
                        │  │  │  NAT Gateway              │   │    │
                        │  │  └──────────────────────────┘   │    │
                        │  │                                   │    │
                        │  │  ┌──────────┐  ┌──────────┐     │    │
                        │  │  │ Private  │  │ Private  │     │    │
                        │  │  │ 10.0.2.0 │  │ 10.0.3.0 │     │    │
                        │  │  │ Node 3   │  │ Node 4   │     │    │
                        │  │  └──────────┘  └──────────┘     │    │
                        │  └─────────────────────────────────┘    │
                        │                                          │
                        │  EKS Control Plane (AWS Managed)         │
                        │  ECR: 991727098679.dkr.ecr...            │
                        └─────────────────────────────────────────┘
```

---

## Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| Terraform | ~> 1.6.0 | Infrastructure as Code |
| AWS Provider | ~> 5.0 | AWS resource management |
| Kubernetes | v1.29.15 | Container orchestration |
| EKS | v1.29 | Managed Kubernetes on AWS |
| Node.js | 18.20-alpine | Sample application |
| Docker | buildx | Multi-platform image builds |
| kubectl | latest | Kubernetes CLI |

---

## Project Structure

```
week-5/
├── main.tf                   # Root — calls vpc + eks modules
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── backend.tf                # S3 remote state config
├── modules/
│   └── eks/
│       ├── main.tf           # EKS cluster + node groups + IAM
│       ├── variables.tf      # Module input variables
│       └── outputs.tf        # Module outputs
└── k8s/
    ├── deployment.yaml       # Node.js app, 2 replicas
    ├── service.yaml          # LoadBalancer, port 80 -> 3000
    ├── configmap.yaml        # APP_ENV=production
    └── secret.yaml           # DB_PASSWORD (base64 encoded)
```

---
