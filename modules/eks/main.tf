module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_enabled_log_types = var.cluster_enabled_log_types

  cluster_compute_config = {
    enabled    = true
    node_pools = var.cluster_node_pools
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = var.tags
} 