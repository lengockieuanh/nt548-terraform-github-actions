provider "aws" {
  region = var.region
}

locals {
  project_name = "lab02-group10"
}

resource "aws_instance" "ec2_instance" {
  for_each = { for idx, config in var.instances_configuration : idx => config }

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids
  key_name              = each.value.key_name

  root_block_device {
    volume_size           = each.value.root_block_device.volume_size
    volume_type           = each.value.root_block_device.volume_type
    delete_on_termination = true
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint              = "enabled"
  }

  tags = merge(
    each.value.tags,
    {
      Name = "${var.environment}-${local.project_name}-${each.key}"
    }
  )

  user_data                   = each.value.user_data_file != null ? file(each.value.user_data_file) : null
  associate_public_ip_address = each.value.associate_elastic_ip
  iam_instance_profile        = each.value.iam_instance_profile
  monitoring                  = true
  ebs_optimized              = true
}

# Resource to create Elastic IPs only for instances with associate_elastic_ip = true
resource "aws_eip" "elastic_ips" {
  for_each = { for idx, config in var.instances_configuration : idx => config if config.associate_elastic_ip }

  tags = {
    Name = "${local.project_name}-eip-${each.key}"
  }
}

# Resource to associate Elastic IPs with instances where associate_elastic_ip = true
resource "aws_eip_association" "eip_association" {
  for_each = { for idx, config in var.instances_configuration : idx => config if config.associate_elastic_ip }

  instance_id   = aws_instance.ec2_instance[each.key].id
  allocation_id = aws_eip.elastic_ips[each.key].id
}