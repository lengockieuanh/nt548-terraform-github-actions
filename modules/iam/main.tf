locals {
  name_prefix = "${var.environment}-${var.role_name}"
}

resource "aws_iam_role" "ec2_role" {
  name               = local.name_prefix
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  
  tags = merge(
    var.tags,
    {
      Name        = local.name_prefix
      Environment = var.environment
    }
  )
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "${local.name_prefix}-secrets-policy"
  description = "Policy for ${local.name_prefix} to access Secrets Manager"
  
  policy = data.aws_iam_policy_document.secrets_manager_policy.json

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-secrets-policy"
      Environment = var.environment
    }
  )
}

data "aws_iam_policy_document" "secrets_manager_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = var.secret_arns
  }
}

resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.name_prefix}-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-profile"
      Environment = var.environment
    }
  )
}