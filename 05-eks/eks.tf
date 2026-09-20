module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name
  kubernetes_version = "1.33"

  # Public endpoint is convenient for learning. In production, set this to
  # false and reach the API server through a bastion or VPN, or restrict it
  # with endpoint_public_access_cidrs.
  endpoint_public_access = true

  # Adds whoever runs `terraform apply` as a cluster admin via an EKS
  # access entry. Without this you get a cluster you cannot kubectl into.
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  addons = {
    vpc-cni                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    coredns                = { most_recent = true }
    eks-pod-identity-agent = { most_recent = true }
  }

  eks_managed_node_groups = {
    general = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 5
      desired_size = 2

      # SPOT is 60-70% cheaper and fine for stateless workloads.
      # Switch to ON_DEMAND for anything that cannot tolerate interruption.
      capacity_type = "SPOT"

      labels = {
        role = "general"
      }
    }
  }

  tags = local.tags
}
