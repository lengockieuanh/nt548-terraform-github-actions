### Common Variables
variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc)"
  default     = "dev"
}

### VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

### Security Group Variables
variable "cidr_block" {
  type        = string
  description = "CIDR block for security group ingress"
  default     = "0.0.0.0/0"
}

### EC2 Variables
variable "key_name" {
  type        = string
  description = "Name of SSH key pair"
  default     = "nt548-lab2"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
  default     = "ami-069cb3204f7a90763" # Amazon Linux 2 in ap-southeast-1
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instances_configuration" {
  type = list(object({
    count         = number
    ami           = string
    instance_type = string
    root_block_device = object({
      volume_size = number
      volume_type = string
    })
    tags                   = map(string)
    vpc_security_group_ids = list(string)
    subnet_id              = string
    user_data_file         = optional(string, null)
    key_name               = string
    associate_elastic_ip   = bool
    iam_instance_profile   = optional(string, null)
  }))

  description = "Configuration for EC2 instances"

  default = [
    {
      count         = 1
      ami           = "ami-069cb3204f7a90763"
      instance_type = "t2.micro"
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "public-instance"
      }
      vpc_security_group_ids = null
      subnet_id              = null
      user_data_file         = "user-data.sh"
      key_name               = "nt548-lab2"
      associate_elastic_ip   = true
      iam_instance_profile   = "ec2-role-instance-profile"
    },
    {
      count         = 1
      ami           = "ami-069cb3204f7a90763"
      instance_type = "t2.micro"
      root_block_device = {
        volume_size = 8
        volume_type = "gp2"
      }
      tags = {
        Name = "private-instance"
      }
      vpc_security_group_ids = null
      subnet_id              = null
      user_data_file         = null
      key_name               = "nt548-lab2"
      associate_elastic_ip   = false
      iam_instance_profile   = null
    }
  ]
}