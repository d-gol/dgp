terraform {
  backend "s3" {
    bucket = "cern-tf-state"
    key = "dejan-kubeflow-6/bootstrap/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.62.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_eks_cluster" "cluster" {
  name = module.aws-bootstrap.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.aws-bootstrap.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


module "aws-bootstrap" {
  source = "./aws-bootstrap"

### BEGIN MANUAL SECTION <<aws-bootstrap>>

### END MANUAL SECTION <<aws-bootstrap>>


  vpc_name = "dejan-kubeflow-6-vpc"
  cluster_name = "dejan-kubeflow-6"
  
  map_roles = [
    {
      rolearn = "arn:aws:iam::332124921534:role/dejan-kubeflow-6-console"
      username = "console"
      groups = ["system:masters"]
    }
  ]

}


module "aws-efs" {
  source = "./aws-efs"

### BEGIN MANUAL SECTION <<aws-efs>>

### END MANUAL SECTION <<aws-efs>>


  cluster_name = module.aws-bootstrap.cluster_name
  vpc_name = "dejan-kubeflow-6-vpc"
  namespace = "bootstrap"
  cluster_private_subnets = module.aws-bootstrap.cluster_private_subnets
  cluster_private_subnet_ids = module.aws-bootstrap.cluster_private_subnet_ids
  

}
