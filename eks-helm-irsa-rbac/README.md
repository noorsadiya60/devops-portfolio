# Week 6 — What I Built

**Focus:** Helm · IRSA · NetworkPolicy · RBAC on EKS (ap-south-1)

---

## Infrastructure

- Re-provisioned EKS cluster using Terraform (upgraded from k8s 1.29 → 1.31)
- Remote state in S3 + DynamoDB lock (ap-south-1)
- 4 worker nodes across 3 AZs

---

## Task 1 — Helm

Built a Helm chart from scratch without using `helm create`.

**Files written manually:**
- `Chart.yaml` — chart metadata, name, version, appVersion
- `values.yaml` — replicaCount, image, service config
- `templates/deployment.yaml` — Go template syntax referencing values
- `templates/service.yaml` — ClusterIP service referencing values

**What I practised:**
- `helm template` to validate rendering before deploying
- `helm lint` for syntax checks
- `helm install` → revision 1 (2 pods)
- `helm upgrade` → revision 2 (4 pods)
- `helm rollback` → revision 3 (back to 2 pods, new revision created)

**Key concept:** Helm rollback creates a new revision — it never removes history.

---

## Task 2 — IRSA (IAM Roles for Service Accounts)

Gave a pod access to S3 without any static credentials.

**Steps:**
1. Associated OIDC provider with EKS cluster via `eksctl`
2. Wrote `trust-policy.json` with `StringEquals` conditions on `sub` and `aud`
3. Created IAM role using the trust policy
4. Attached `AmazonS3ReadOnlyAccess` to the role
5. Created Kubernetes ServiceAccount with role ARN annotation
6. Deployed test pod using that ServiceAccount
7. Verified with `aws s3 ls` from inside the pod — no access keys present

**Verified:** Pod had `AWS_ROLE_ARN` and `AWS_WEB_IDENTITY_TOKEN_FILE` injected. No `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY`.

**Also documented:** Terraform equivalent using `aws_iam_openid_connect_provider`, `aws_iam_role`, `data.aws_iam_policy_document`, `kubernetes_service_account`.

---

## Task 3 — NetworkPolicy

Restricted pod-to-pod traffic so only the `frontend` namespace can reach `backend` pods.

**Steps:**
1. Created `frontend` and `backend` namespaces
2. Deployed test pods in each namespace + `other-pod` in default
3. Confirmed baseline — all pods could reach backend (default Kubernetes behaviour)
4. Wrote and applied `NetworkPolicy` with `namespaceSelector` for frontend
5. Enabled NetworkPolicy enforcement on EKS by installing `vpc-cni` as a managed addon with `enableNetworkPolicy: true`
6. Verified — frontend pod succeeded, other-pod timed out (exit code 28)

**Key concept:** NetworkPolicy needs CNI enforcement. EKS VPC CNI does not enforce it by default. Must be enabled via EKS addon API — not by manually editing the daemonset.

---

## Task 4 — RBAC

Created a ServiceAccount that can only `get` and `list` pods in the `dev` namespace.

**Files written:**
- `role.yaml` — Role with `apiGroups: [""]`, `resources: ["pods"]`, `verbs: ["get", "list"]`
- `rolebinding.yaml` — bound the Role to `dev-reader` ServiceAccount

**Verified with `kubectl auth can-i`:**

| Command | Result |
|---------|--------|
| get pods in dev | yes |
| list pods in dev | yes |
| delete pods in dev | no |
| get pods in default | no |

**Key concept:** Role is namespace-scoped. ClusterRole is cluster-wide. RoleBinding is immutable after creation.

---

