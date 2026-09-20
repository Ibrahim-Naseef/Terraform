module "dev-infra"{
    source = "./infra-app"
    env = "dev"
    bucket_name = "cyberz-dev-bucket"
    instance_count = 1
    instance_type = "t3.micro"
    ami_id = "ami-01a00762f46d584a1"
    hash_key = "studentID"
}

module "stg-infra"{
    source = "./infra-app"
    env = "stg"
    bucket_name = "cyberz-stg-bucket"
    instance_count = 1
    instance_type = "t3.micro"
    ami_id = "ami-01a00762f46d584a1"
    hash_key = "studentID"
}

module "prod-infra"{
    source = "./infra-app"
    env = "prod"
    bucket_name = "cyberz-prod-bucket"
    instance_count = 1
    instance_type = "t3.small"
    ami_id = "ami-01a00762f46d584a1"
    hash_key = "studentID"
}