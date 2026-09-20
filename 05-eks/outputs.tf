output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the control plane"
  value       = module.eks.cluster_version
}

output "cluster_security_group_id" {
  description = "Security group attached to the control plane"
  value       = module.eks.cluster_security_group_id
}

output "vpc_id" {
  description = "VPC the cluster runs in"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnets hosting the worker nodes"
  value       = module.vpc.private_subnets
}

output "configure_kubectl" {
  description = "Run this to point kubectl at the new cluster"
  value       = "aws eks update-kubeconfig --region ${local.region} --name ${module.eks.cluster_name}"
}
