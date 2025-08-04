module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "19.16.0"

    cluster_name    = var.cluster_name
    cluster_version = "1.28"

    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets

    cluster_endpoint_public_access = true
    cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # Allows access from any IP address


    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"
    }

    eks_managed_node_groups = {
        one = {
        name           = "general-nodes"
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 2
        }
    }
}