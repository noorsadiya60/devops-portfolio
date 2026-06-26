# EKS Autoscaling — HPA & PodDisruptionBudget

Week 7 of a hands-on SRE upskilling project. This module covers horizontal pod autoscaling (HPA) and pod disruption budgets (PDB) on a Terraform-provisioned Amazon EKS cluster, with a heavy focus on diagnosing real failures rather than following a happy path.

## What this demonstrates

- Configuring CPU-based HPA (`autoscaling/v2`) on a Node.js deployment
- Generating load with k6 and observing the full scale-up / scale-down lifecycle
- Writing and testing a PodDisruptionBudget against `kubectl drain`
- Diagnosing EKS-specific issues: pod-density limits, VPC CNI prefix delegation, metrics-server setup, and token expiry

## Architecture

- **Cluster:** Amazon EKS 1.31, provisioned via Terraform (region `ap-south-1`)
- **Nodes:** Managed node groups (public + private), `t3.micro` instances
- **Workload:** Node.js (Express) app, 2 replicas, deployed from a private ECR image
- **Metrics:** Kubernetes metrics-server (the dependency HPA reads from)
- **State:** Remote Terraform state in S3 with DynamoDB locking

## Repository layout

```
eks-autoscaling-karpenter/
├── manifests/
│   ├── deployment.yaml    # Node.js app, 2 replicas, CPU/memory requests + limits
│   ├── hpa.yaml           # HorizontalPodAutoscaler, 50% CPU target, min 2 / max 6
│   ├── pdb.yaml           # PodDisruptionBudget, minAvailable: 1
│  
├── load-test.js           # k6 load script (200 virtual users, 3 min)
└── README.md
```

