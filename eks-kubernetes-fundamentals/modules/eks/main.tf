resource "aws_iam_role" "eks_nodegroup_role" {
    name = "${local.name}_eks_nodegroup_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "workernode_policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy"{
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks_nodegroup_role.name

}

resource "aws_iam_role" "eks_master_role" {
    name = "${local.name}_eks_master_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_master_role.name
}


resource "aws_eks_cluster" "eks_cluster" {
    name = "${local.name}_eks_cluster"
    version = "1.31"
    role_arn = aws_iam_role.eks_master_role.arn
    vpc_config {
      subnet_ids = concat([var.public_subnet_id], var.private_subnet_ids)
      endpoint_private_access = true
      endpoint_public_access = true
    }

}
resource "aws_eks_node_group" "public_nodes" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.name}_eks_ng_public"
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids = [var.public_subnet_id]

  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t3.micro"]
  
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.workernode_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_policy,
  ]

}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.name}_eks_ng_private"
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids = var.private_subnet_ids

  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t3.micro"]
  
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
   depends_on = [
    aws_iam_role_policy_attachment.workernode_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_policy,
  ]
}
locals{
    name = "${var.env}"
}
