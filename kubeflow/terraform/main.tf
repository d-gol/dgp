terraform {
  backend "s3" {
    bucket = "cern-tf-state"
    key = "dejan-kubeflow-6/kubeflow/terraform.tfstate"
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
  name = "dejan-kubeflow-6"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "dejan-kubeflow-6"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


module "aws" {
  source = "./aws"

### BEGIN MANUAL SECTION <<aws>>

### END MANUAL SECTION <<aws>>


  namespace = "kubeflow"
  pipelines_bucket = "cern-dejan-kubeflow-6-kubeflow-pipelines"
  cluster_name = "dejan-kubeflow-6"
  

}
