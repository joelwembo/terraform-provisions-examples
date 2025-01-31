terraform {
  required_version = "~> 1.3"

  backend "s3" {
    bucket         = "YOUR_BUCKET_NAME"
    key            = "tf-infra/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "YOUR_TABLE_NAME"
    encrypt        = true
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "ccVPC" {
  source = "./modules/vpc"

  vpc_cidr             = local.vpc_cidr
  vpc_tags             = var.vpc_tags
  availability_zones   = local.availability_zones
  public_subnet_cidrs  = local.public_subnet_cidrs
  private_subnet_cidrs = local.private_subnet_cidrs
}

module "db" {
  source = "./modules/db"

  cc_vpc_id               = module.ccVPC.vpc_id
  cc_private_subnets      = module.ccVPC.private_subnets
  cc_private_subnet_cidrs = local.private_subnet_cidrs

  db_az            = local.availability_zones[0]
  db_name          = "ccDatabaseInstance"
  db_user_name     = var.db_user_name
  db_user_password = var.db_user_password
}

module "webserver" {
  source = "./modules/webserver"

  cc_vpc_id         = module.ccVPC.vpc_id
  cc_public_subnets = module.ccVPC.public_subnets
}