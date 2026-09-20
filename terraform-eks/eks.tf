module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # Renamed from cluster_addons to addons in v21.x
  addons = {
    vpc-cni = {
      most-recent = true
    }
    kube-proxy = {
      most-recent = true
    }
    coredns = {
      most-recent = true
    }
  }

# Correct argument name for EKS Managed Node Groups in v21.x
  eks_managed_node_groups = {
    tf-cluster = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]

      min_size     = 2
      max_size     = 10
      desired_size = 2

      capacity_type = "SPOT"
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}