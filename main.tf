terraform {

  backend "s3" {
    bucket         = "btf-state-backend"
    key            = "tf-infra/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "btf-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "tf-state" {
  source = "./modules/tf-state"

  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "tfVPC" {
  source = "./modules/vpc"

  vpc_cidr             = local.vpc_cidr
  vpc_tags             = var.vpc_tags
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}

module "bastion" {
  source = "./modules/bastion"

  tf_vpc_id         = module.tfVPC.vpc_id
  tf_public_subnets = module.tfVPC.public_subnets
}

module "ecrRepo" {
  source = "./modules/ecr"

  ecr_repo_name = local.ecr_repo_name
}


module "eks" {
  source = "./modules/eks"

  tf_vpc_id         = module.tfVPC.vpc_id
  tf_public_subnets = module.tfVPC.public_subnets
}

module "database" {
  source = "./modules/database"

  tf_vpc_id               = module.tfVPC.vpc_id
  tf_private_subnets      = module.tfVPC.private_subnets
  tf_private_subnet_cidrs = local.private_subnet_cidrs

  db_az            = local.availability_zones[0]
  db_name          = var.db_name
  db_user_name     = var.db_user_name
  db_user_password = var.db_user_password
}
