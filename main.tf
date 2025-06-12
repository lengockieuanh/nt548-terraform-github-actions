terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.46"
    }
  }

  backend "s3" {
    bucket         = "nt548-terraform-lab2-group10" # Changed bucket name
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_state_lock" # Changed table name
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

### Declare the VPC module
module "vpc_module" {
  source              = "./modules/vpc"
  region              = var.region
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}


### Declare the NAT Gateway module
module "nat_gateway_module" {
  source     = "./modules/nat_gateway"
  region     = var.region
  subnet_ids = module.vpc_module.public_subnet_id[0]
}


### Declare the Route table module
module "route_table_module" {
  source             = "./modules/route_tables"
  region             = var.region
  vpc_ids            = module.vpc_module.vpc_id
  igw_ids            = module.vpc_module.igw_id
  nat-gateway_ids    = module.nat_gateway_module.nat_gateway_id
  public_subnet_ids  = module.vpc_module.public_subnet_id[0]
  private_subnet_ids = module.vpc_module.private_subnet_id[0]
}

### Declare the Security Group module
module "security_group_module" {
  source     = "./modules/security_groups"
  vpc_id     = module.vpc_module.vpc_id
  cidr_block = var.cidr_block
}

### Declare the IAM module
module "iam_module" {
  source      = "./modules/iam"
  environment = var.environment
}

### Declare the EC2 module
module "ec2_module" {
  source      = "./modules/ec2"
  environment = var.environment
  vpc_id      = module.vpc_module.vpc_id
  ami_id      = var.ami_id

  instances_configuration = [{
    count                  = var.instances_configuration[0].count
    ami                    = var.instances_configuration[0].ami
    instance_type          = var.instances_configuration[0].instance_type
    root_block_device      = var.instances_configuration[0].root_block_device
    tags                   = var.instances_configuration[0].tags
    vpc_security_group_ids = [module.security_group_module.public_sg_id] # Changed from public_ssh_sg_id
    subnet_id              = module.vpc_module.public_subnet_id[0]
    user_data_file         = var.instances_configuration[0].user_data_file
    key_name               = var.instances_configuration[0].key_name
    associate_elastic_ip   = var.instances_configuration[0].associate_elastic_ip
    iam_instance_profile   = module.iam_module.instance_profile_name
    },
    {
      count                  = var.instances_configuration[1].count
      ami                    = var.instances_configuration[1].ami
      instance_type          = var.instances_configuration[1].instance_type
      root_block_device      = var.instances_configuration[1].root_block_device
      tags                   = var.instances_configuration[1].tags
      vpc_security_group_ids = [module.security_group_module.private_sg_id] # Changed from private_ssh_sg_id
      subnet_id              = module.vpc_module.private_subnet_id[0]
      user_data_file         = var.instances_configuration[1].user_data_file
      key_name               = var.instances_configuration[1].key_name
      associate_elastic_ip   = var.instances_configuration[1].associate_elastic_ip
      iam_instance_profile   = var.instances_configuration[1].iam_instance_profile
  }]
}