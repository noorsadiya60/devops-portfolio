## Week 2 — AWS Account + Tools Setup

**Focus:** Cloud foundations, toolchain setup, ECR

**What I did:**
- Created AWS account with root MFA enabled
- Created IAM user `noor1` with AdministratorAccess
- Set billing alert at $50 (SNS → email)
- Installed and verified: AWS CLI v2, Terraform, kubectl, Helm, Git
- Configured AWS CLI for region `ap-south-1` (Mumbai)
- Created private ECR repository `myapp`
- Tagged and pushed Week 1 optimised Docker image to ECR as `v1`

**Verification:**
- `aws sts get-caller-identity` → confirmed account ID
- All 5 tools showing version in terminal
- Image visible in ECR: `<account>.dkr.ecr.ap-south-1.amazonaws.com/myapp:v1`
