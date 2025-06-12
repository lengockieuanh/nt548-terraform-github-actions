output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}