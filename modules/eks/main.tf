variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = "1.30"

  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

resource "aws_eks_node_group" "managed_workers" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "managed-worker-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }
}
