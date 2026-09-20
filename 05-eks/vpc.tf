module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13" # always pin a registry module

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  # One NAT gateway instead of three. Saves roughly two thirds of the NAT
  # bill in a learning account; use one per AZ for real production HA.
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  # These tags are not decoration. The AWS Load Balancer Controller reads
  # them to decide where to place internet-facing and internal load balancers.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = local.tags
}
