data "aws_key_pair" "existing_key_pair" {
  key_name = "linuxvm"
}

# Create node group
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "btf-node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [var.tf_public_subnets[0].id, var.tf_public_subnets[1].id]
  capacity_type   = "ON_DEMAND"
  disk_size       = "20"
  instance_types  = ["t2.micro"]

  remote_access {
    ec2_ssh_key               = data.aws_key_pair.existing_key_pair.key_name
    source_security_group_ids = [aws_security_group.tfWebserverSecurityGroup.id]
  }

  labels = tomap({ env = "dev" })

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
