resource "aws_eks_cluster" "eks" {
  name     = "btf-eks"
  role_arn = aws_iam_role.master.arn


  vpc_config {
    subnet_ids = [var.tf_public_subnets[0].id, var.tf_public_subnets[1].id]
  }

  depends_on = [
    aws_iam_role.master,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}