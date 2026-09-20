# EKS

## Build

```bash
cd 05-eks
terraform init
terraform plan
terraform apply          # 12-15 minutes

aws eks update-kubeconfig --region ap-south-1 --name tf-eks-cluster
kubectl get nodes
```

## Architecture

```
VPC 10.0.0.0/16  (3 AZs)
├── public   10.0.101-103.0/24   NAT gateway, internet-facing LBs
├── private  10.0.1-3.0/24       worker nodes  (outbound via NAT only)
└── intra    10.0.5-7.0/24       control plane ENIs  (no internet route)

EKS 1.33 control plane
└── managed node group: t3.medium SPOT, 2-5 nodes, AL2023
    add-ons: vpc-cni, kube-proxy, CoreDNS, pod-identity-agent
```

## Decisions worth understanding

**Three subnet tiers.** Nodes in private subnets cannot be reached from the internet. Control plane ENIs in intra subnets have no outbound route at all. Public subnets exist only for NAT and load balancers.

**Subnet tags are load-bearing.** `kubernetes.io/role/elb = 1` on public subnets and `kubernetes.io/role/internal-elb = 1` on private ones tell the AWS Load Balancer Controller where to attach a `Service` of type `LoadBalancer`. Miss them and your service hangs in `<pending>` forever.

**`enable_cluster_creator_admin_permissions = true`.** Without it you get a cluster whose API server rejects you. EKS access entries replaced the old `aws-auth` ConfigMap dance.

**`single_nat_gateway = true`.** One NAT instead of three saves roughly $65/month. Production wants one per AZ so a single AZ failure does not kill egress for the whole cluster.

**SPOT capacity.** 60-70% cheaper, interruptible with two minutes' notice. Fine for stateless workloads, wrong for anything holding local state.

## Cost

Control plane ~$73/month, plus nodes, plus ~$33/month per NAT gateway. Destroy when you are done.

## Destroy hangs

Kubernetes creates AWS resources Terraform does not know about. A `Service` of type `LoadBalancer` leaves an ELB holding the subnets, and `terraform destroy` waits forever on subnet deletion.

```bash
kubectl delete svc --all --all-namespaces
kubectl delete ingress --all --all-namespaces
terraform destroy
```

## Next steps

- Move state to S3 (uncomment the backend block in `terraform.tf`)
- IRSA / Pod Identity for workload AWS permissions
- AWS Load Balancer Controller and Cluster Autoscaler via the `helm` provider
- Argo CD for GitOps delivery onto the cluster
