resource "yba_installer" "install" {
  provider                  = yba.unauthenticated
  ssh_host_ip               = "52.198.247.210"
  ssh_user                  = "ec2-user"
  ssh_private_key_file_path = "../.ssh/yba_rsa"
  yba_license_file          = "../yba_license.lic"
  yba_version               = "2.20.4.0-b50"
}

# # https://docs.yugabyte.com/preview/reference/configuration/operating-systems/
# resource "yba_cloud_provider" "aws" {
#   code = "aws"
#   name = "aws-provider"
#   aws_config_settings {
#     use_iam_instance_profile = true
#   }
#   regions {
#     code              = "ap-northeast-1"
#     name              = "ap-northeast-1"
#     security_group_id = "sg-0ec5404bc569c53bc"
#     vnet_name         = "vpc-0e4c6e7c6f2585123"
#     yb_image          = "ami-04098447374373198"
#     zones {
#       code   = "ap-northeast-1a"
#       name   = "ap-northeast-1a"
#       subnet = "subnet-05c3e2e0ed364598c"
#     }
#     zones {
#       code   = "ap-northeast-1c"
#       name   = "ap-northeast-1c"
#       subnet = "subnet-0b5914ab9175acc68"
#     }
#     zones {
#       code   = "ap-northeast-1d"
#       name   = "ap-northeast-1d"
#       subnet = "subnet-01ec8a1573c2d5690"
#     }
#   }
#   regions {
#     code              = "us-east-1"
#     name              = "us-east-1"
#     security_group_id = "sg-0fad64ab07a31b78a"
#     vnet_name         = "vpc-01c4afd29f84eaa22"
#     yb_image          = "ami-0241b1d769b029352"
#     zones {
#       code   = "us-east-1a"
#       name   = "us-east-1a"
#       subnet = "subnet-0fa72e9bc866d3570"
#     }
#     zones {
#       code   = "us-east-1c"
#       name   = "us-east-1c"
#       subnet = "subnet-02d30632e489bd42b"
#     }
#     zones {
#       code   = "us-east-1d"
#       name   = "us-east-1d"
#       subnet = "subnet-0f36d674c3449c59c"
#     }
#   }
#   regions {
#     code              = "eu-west-2"
#     name              = "eu-west-2"
#     security_group_id = "sg-08e575438a9f37964"
#     vnet_name         = "vpc-07bdfc46206f6f86d"
#     yb_image          = "ami-07b52d1e1530cb501"
#     zones {
#       code   = "eu-west-2a"
#       name   = "eu-west-2a"
#       subnet = "subnet-0cb3e66ae580e28af"
#     }
#     zones {
#       code   = "eu-west-2b"
#       name   = "eu-west-2b"
#       subnet = "subnet-02c5ac9e312ac950a"
#     }
#     zones {
#       code   = "eu-west-2c"
#       name   = "eu-west-2c"
#       subnet = "subnet-027e767514e887f5a"
#     }
#   }
#   ssh_port        = 22
#   air_gap_install = false
# }
#
# resource "yba_cloud_provider" "aws_airgap" {
#   code = "aws"
#   name = "aws-provider-airgap"
#   aws_config_settings {
#     use_iam_instance_profile = true
#   }
#   regions {
#     code              = "ap-northeast-1"
#     name              = "ap-northeast-1"
#     security_group_id = "sg-0ec5404bc569c53bc"
#     vnet_name         = "vpc-0e4c6e7c6f2585123"
#     yb_image          = "ami-04098447374373198"
#     zones {
#       code   = "ap-northeast-1a"
#       name   = "ap-northeast-1a"
#       subnet = "subnet-05c3e2e0ed364598c"
#     }
#     zones {
#       code   = "ap-northeast-1c"
#       name   = "ap-northeast-1c"
#       subnet = "subnet-0b5914ab9175acc68"
#     }
#     zones {
#       code   = "ap-northeast-1d"
#       name   = "ap-northeast-1d"
#       subnet = "subnet-01ec8a1573c2d5690"
#     }
#   }
#   regions {
#     code              = "us-east-1"
#     name              = "us-east-1"
#     security_group_id = "sg-0fad64ab07a31b78a"
#     vnet_name         = "vpc-01c4afd29f84eaa22"
#     yb_image          = "ami-0241b1d769b029352"
#     zones {
#       code   = "us-east-1a"
#       name   = "us-east-1a"
#       subnet = "subnet-0fa72e9bc866d3570"
#     }
#     zones {
#       code   = "us-east-1c"
#       name   = "us-east-1c"
#       subnet = "subnet-02d30632e489bd42b"
#     }
#     zones {
#       code   = "us-east-1d"
#       name   = "us-east-1d"
#       subnet = "subnet-0f36d674c3449c59c"
#     }
#   }
#   regions {
#     code              = "eu-west-2"
#     name              = "eu-west-2"
#     security_group_id = "sg-08e575438a9f37964"
#     vnet_name         = "vpc-07bdfc46206f6f86d"
#     yb_image          = "ami-07b52d1e1530cb501"
#     zones {
#       code   = "eu-west-2a"
#       name   = "eu-west-2a"
#       subnet = "subnet-0cb3e66ae580e28af"
#     }
#     zones {
#       code   = "eu-west-2b"
#       name   = "eu-west-2b"
#       subnet = "subnet-02c5ac9e312ac950a"
#     }
#     zones {
#       code   = "eu-west-2c"
#       name   = "eu-west-2c"
#       subnet = "subnet-027e767514e887f5a"
#     }
#   }
#   ssh_port        = 22
#   air_gap_install = true
# }
#
# data "yba_provider_key" "aws" {
#   provider_id = yba_cloud_provider.aws.id
# }
#
# data "yba_release_version" "release_version" {
#   // To fetch default YBDB version
# }
#
# resource "yba_universe" "demo" {
#   clusters {
#     cluster_type = "PRIMARY"
#     user_intent {
#       universe_name      = "demo"
#       provider_type      = yba_cloud_provider.aws.code
#       provider           = yba_cloud_provider.aws.id
#       region_list        = yba_cloud_provider.aws.regions[*].uuid
#       num_nodes          = 3
#       replication_factor = 3
#       instance_type      = "c5.large"
#       assign_public_ip   = true
#       aws_arn_string     = "arn:aws:iam::456412990288:instance-profile/yb-node"
#       device_info {
#         num_volumes  = 1
#         volume_size  = 40
#         storage_type = "GP3"
#         disk_iops    = 3000
#         throughput   = 125
#       }
#       use_time_sync       = true
#       enable_ysql         = true
#       yb_software_version = data.yba_release_version.release_version.id
#       access_key_code     = data.yba_provider_key.aws.id
#     }
#   }
#   communication_ports {}
# }
#
# resource "yba_universe" "demo_airgap" {
#   clusters {
#     cluster_type = "PRIMARY"
#     user_intent {
#       universe_name      = "demo-airgap"
#       provider_type      = yba_cloud_provider.aws.code
#       provider           = yba_cloud_provider.aws.id
#       region_list        = yba_cloud_provider.aws.regions[*].uuid
#       num_nodes          = 3
#       replication_factor = 3
#       instance_type      = "c5.large"
#       assign_public_ip   = false
#       aws_arn_string     = "arn:aws:iam::456412990288:instance-profile/yb-node"
#       device_info {
#         num_volumes  = 1
#         volume_size  = 40
#         storage_type = "GP3"
#         disk_iops    = 3000
#         throughput   = 125
#       }
#       use_time_sync       = true
#       enable_ysql         = true
#       yb_software_version = data.yba_release_version.release_version.id
#       access_key_code     = data.yba_provider_key.aws.id
#     }
#   }
#   communication_ports {}
# }
