variable "region" {
  type        = string
  default     = "ap-southeast-1"
  description = "Region of IAM role"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, prod)"
}

variable "role_name" {
  type        = string
  description = "The name of the IAM role to create"
  default     = "ec2-role"
}

variable "secret_arns" {
  type        = list(string)
  description = "List of ARNs for the secrets that this role can access"
  default     = [] # Empty default is safer
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}