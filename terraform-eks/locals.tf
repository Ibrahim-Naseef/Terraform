locals{
    region = "ap-south-1"
    name = "tf-eks-cluster"
    vpc_cidr = "10.0.0.0/16"
    azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"    ]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
    intra_subnets = ["10.0.5.0/24", "10.0.6.0/24","10.0.7.0/24"]
    env = "dev"
}