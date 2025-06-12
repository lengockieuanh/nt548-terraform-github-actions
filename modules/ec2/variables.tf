variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region of EC2"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EC2 instances will be created"
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
    user_data_file         = optional(string)
    key_name               = string
    associate_elastic_ip   = bool
    iam_instance_profile   = optional(string)
  }))
  description = "List of EC2 instance configurations"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources"
  default     = {}
}