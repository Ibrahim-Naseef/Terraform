# 05 - Production-shaped EKS cluster

Everything from the earlier folders, applied at once: registry modules, pinned versions, a multi-AZ VPC, a managed node group, and a remote backend.

```bash
terraform init
terraform plan
terraform apply          # roughly 12-15 minutes

$(terraform output -raw configure_kubectl)
kubectl get nodes
kubectl get pods -A
```

## What gets built

| Layer | Resource |
|---|---|
| Network | VPC `10.0.0.0/16` across 3 AZs: public, private and intra subnets |
| Egress | One NAT gateway (cost-saving; use three for production HA) |
| Control plane | EKS 1.33, ENIs placed in the intra subnets |
| Add-ons | vpc-cni, kube-proxy, CoreDNS, EKS Pod Identity agent |
| Data plane | Managed node group, `t3.medium` SPOT, 2-5 nodes |
| Access | Cluster creator added as admin via an EKS access entry |

## Why three subnet tiers

- **public** — NAT gateways and internet-facing load balancers. Has an internet gateway route.
- **private** — worker nodes. Outbound via NAT, no inbound from the internet.
- **intra** — no internet route at all. Control plane ENIs sit here so the API server's network interfaces cannot reach out.

The `kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` subnet tags are load-bearing. Without them the AWS Load Balancer Controller cannot work out where to attach a Service of type `LoadBalancer`.

## Cost warning

A running EKS control plane costs about $0.10/hour, plus nodes, plus roughly $0.045/hour per NAT gateway. Left up for a month that is real money.

```bash
terraform destroy
```

Destroy can hang if Kubernetes created AWS resources behind Terraform's back — a `Service` of type `LoadBalancer` leaves an ELB that holds the subnets hostage. Delete those first:

```bash
kubectl delete svc --all-namespaces --all
terraform destroy
```

## Version pinning

Every registry module here carries an explicit `version`. The EKS module in particular made breaking renames in v21 (`cluster_addons` became `addons`, `cluster_name` became `name`). An unpinned `source` means the next `terraform init` silently upgrades and your plan explodes.
