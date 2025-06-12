variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region of VPC"
}

variable "vpc_ids" {
  type        = string
  description = "ID of VPC that Route Table will be created in"
}

variable "igw_ids" {
  type        = string
  description = "ID of Internet Gateway that Route Table will be created in"
}

variable "nat-gateway_ids" {
  type        = string
  description = "ID of NAT Gateway that Route Table will be created in"
}

variable "public_subnet_ids" {
  type        = string
  description = "ID of Public Subnet that Route Table will be created in"
}

variable "private_subnet_ids" {
  type        = string
  description = "ID of Private Sutẻbnet that Route Table will be created in"
}