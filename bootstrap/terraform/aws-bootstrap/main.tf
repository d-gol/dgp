data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.78.0"
  name                 = var.vpc_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true
  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "cluster" {
  source          = "github.com/pluralsh/terraform-aws-eks?ref=asg-tags"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = concat(module.vpc.public_subnets, module.vpc.private_subnets)
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true
  write_kubeconfig = false

  node_groups_defaults = {
    desired_capacity = var.desired_capacity
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity

    instance_types = var.instance_types
    disk_size = 50
    subnets = module.vpc.private_subnets
    ami_release_version = "1.21.2-20210813"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }

  node_groups = merge(var.base_node_groups, var.node_groups)

  map_users = var.map_users
  map_roles = concat(var.map_roles, var.manual_roles)
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.cluster.cluster_id
  addon_name   = "vpc-cni"
  addon_version     = "v1.10.1-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "vpc-cni"
  }
  depends_on = [
    module.cluster.node_groups
  ]
}

resource "aws_eks_addon" "core_dns" {
  cluster_name      = module.cluster.cluster_id
  addon_name        = "coredns"
  addon_version     = "v1.8.4-eksbuild.1"
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "coredns"
  }
  depends_on = [
    module.cluster.node_groups
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = module.cluster.cluster_id
  addon_name        = "kube-proxy"
  addon_version     = "v1.21.2-eksbuild.2"
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "kube-proxy"
  }
  depends_on = [
    module.cluster.node_groups
  ]
}

resource "kubernetes_namespace" "bootstrap" {
  metadata {
    name = "bootstrap"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bootstrap"
    }
  }

  depends_on = [
    module.cluster.cluster_id
  ]
}

data "aws_subnet_ids" "cluster_private_subnets" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-*"]
  }
  depends_on = [module.vpc]
}

data "aws_subnet_ids" "cluster_public_subnets" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-public-*"]
  }
  depends_on = [module.vpc]
}
