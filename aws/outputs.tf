output "yba_ami_id" {
  value     = module.yba_ec2.ami
  sensitive = true
}

output "node_instance_profile_arn" {
  value = module.node_role.iam_instance_profile_arn
}

output "node_ami_id" {
  value = {
    ap-northeast-1 = data.aws_ssm_parameter.amazonlinux_2_ap_northeast_1.value
    us-east-1      = data.aws_ssm_parameter.amazonlinux_2_us_east_1.value
    eu-west-2      = data.aws_ssm_parameter.amazonlinux_2_eu_west_2.value
  }
  sensitive = true
}
