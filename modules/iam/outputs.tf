output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "instance_profile_arn" {
  description = "The ARN of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.arn
}

output "instance_profile_name" {
  description = "The name of the instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}