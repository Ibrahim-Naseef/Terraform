import sys
from diagram import *

W, H = 900, 520
NF = 60

SUBNETS = [
    ("public subnets", "10.0.101-103.0/24", "NAT gateway  •  internet-facing LBs", 150,
     (70, 130, 180)),
    ("private subnets", "10.0.1-3.0/24", "worker nodes  •  outbound via NAT only", 268,
     (46, 139, 87)),
    ("intra subnets", "10.0.5-7.0/24", "control-plane ENIs  •  no internet route", 386,
     (140, 100, 170)),
]


def frame(t):
    c = Canvas(W, H)
    c.text(W / 2, 24, "Terraform  ->  EKS cluster on AWS", size=15, bold=True)
    c.text(W / 2, 44, "one apply: VPC across 3 AZs, control plane, managed node group, add-ons",
           size=9.5, fill=GREY)

    cloudbox(c, (150, 66, 878, 462), "AWS REGION  ap-south-1", col=AWS_ORANGE)
    cloudbox(c, (176, 92, 520, 444), "VPC  10.0.0.0/16", col=(70, 130, 180),
             sub="3 availability zones")
    cloudbox(c, (556, 92, 858, 444), "EKS CLUSTER  tf-eks-cluster", col=K8S_BLUE,
             sub="v1.33")

    # ---- terraform ----
    terraform(c, 74, 250, label="Terraform")
    c.text(74, 292, "05-eks/", size=8.5, fill=GREY)

    e_apply = [(112, 258), (170, 262)]
    arrow(c, e_apply, "1  terraform apply", label_off=(16, -17), label_size=9.5,
          label_pos=0.5)

    # ---- subnets ----
    for name, cidr, note, y, col in SUBNETS:
        c.rect((196, y - 26, 500, y + 26), fill=(250, 251, 253), outline=col,
               width=1.3, radius=5)
        c.text(208, y - 12, name, size=10, bold=True, fill=col, anchor="lm")
        c.text(492, y - 12, cidr, size=8.5, fill=GREY, anchor="rm")
        c.text(208, y + 8, note, size=8.5, fill=(90, 96, 105), anchor="lm")

    # ---- cluster ----
    kubernetes(c, 660, 180, label="EKS control plane", sub="managed by AWS")
    server(c, 660, 360, n=3, col=(46, 139, 87), label="Managed node group",
           sub="t3.medium  SPOT  2-5 nodes")

    c.rect((762, 140, 848, 232), fill=(246, 249, 255), outline=K8S_BLUE, width=1.2,
           radius=5)
    c.text(805, 155, "add-ons", size=9, bold=True, fill=K8S_BLUE)
    for i, a in enumerate(["vpc-cni", "kube-proxy", "coredns", "pod-identity"]):
        c.text(805, 174 + i * 14, a, size=8.5, fill=(90, 96, 105))

    # ---- edges ----
    e_cp = [(504, 392), (532, 392), (532, 196), (630, 186)]
    e_nodes = [(504, 282), (560, 320), (620, 348)]
    e_addon = [(692, 196), (740, 200), (758, 190)]
    e_join = [(660, 224), (660, 320)]

    arrow(c, e_cp, None)
    c.text(348, 424, "2   intra subnets host the control-plane ENIs", size=9,
           bold=True, fill=(140, 100, 170))
    arrow(c, e_nodes, "3  worker nodes", label_off=(16, -15), label_size=9.5,
          label_pos=0.58)
    arrow(c, e_addon, None, width=1.2, head=6)
    arrow(c, e_join, "4  nodes register", label_off=(62, 0), label_size=9.5)

    for e, n in ((e_apply, 1), (e_cp, 3), (e_nodes, 2), (e_addon, 1), (e_join, 2)):
        travellers(c, e, t, n=n)

    # ---- bottom strip ----
    c.rect((22, 478, 878, 508), fill=(244, 246, 250), radius=5)
    c.text(W / 2, 493,
           "aws eks update-kubeconfig --region ap-south-1 --name tf-eks-cluster"
           "        ->        kubectl get nodes",
           size=9.5, bold=True, fill=(70, 80, 95))
    return c.result()


if __name__ == "__main__":
    if "--png" in sys.argv:
        frame(0.0).save("../preview3.png")
    else:
        save_gif("../terraform-eks.gif",
                 [frame(i / NF) for i in range(NF)], duration=70)
        print("ok")
