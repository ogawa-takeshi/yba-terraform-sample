locals {
  yba_cluster_1_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.yba_cluster_1.id
  yba_cluster_2_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.yba_cluster_2.id
  yba_cluster_3_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.yba_cluster_3.id

  cluster_1_cluster_2_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.cluster_1_cluster_2.id
  cluster_2_cluster_3_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.cluster_2_cluster_3.id
  cluster_3_cluster_1_vpc_peering_connection_id = aws_vpc_peering_connection_accepter.cluster_3_cluster_1.id
}

# VPCs

module "yba_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.ap-northeast-1
  }

  name           = "yba"
  cidr           = "10.0.0.0/16"
  azs            = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  #   private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  #   intra_subnets   = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
}

module "cluster_vpc_1" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.ap-northeast-1
  }

  name           = "yb-cluster-1"
  cidr           = "10.1.0.0/16"
  azs            = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
  #   private_subnets = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  #   intra_subnets   = ["10.1.8.0/24", "10.1.9.0/24", "10.1.10.0/24"]
}

module "cluster_vpc_2" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.us-east-1
  }

  name           = "yb-cluster-2"
  cidr           = "10.2.0.0/16"
  azs            = ["us-east-1a", "us-east-1c", "us-east-1d"]
  public_subnets = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
  #   private_subnets = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
  #   intra_subnets   = ["10.2.8.0/24", "10.2.9.0/24", "10.2.10.0/24"]
}

module "cluster_vpc_3" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.eu-west-2
  }

  name           = "yb-cluster-3"
  cidr           = "10.3.0.0/16"
  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets = ["10.3.0.0/24", "10.3.1.0/24", "10.3.2.0/24"]
  #   private_subnets = ["10.3.4.0/24", "10.3.5.0/24", "10.3.6.0/24"]
  #   intra_subnets   = ["10.3.8.0/24", "10.3.9.0/24", "10.3.10.0/24"]
}

# VPC Peering YBA → Cluster1

resource "aws_vpc_peering_connection" "yba_cluster_1" {
  provider = aws.ap-northeast-1

  vpc_id      = module.yba_vpc.vpc_id
  peer_vpc_id = module.cluster_vpc_1.vpc_id
  peer_region = "ap-northeast-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "yba_cluster_1" {
  provider = aws.ap-northeast-1

  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_1.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "yba_cluster_1" {
  provider = aws.ap-northeast-1

  vpc_peering_connection_id = local.yba_cluster_1_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "yba_cluster_1" {
  provider = aws.ap-northeast-1
  for_each = toset(module.yba_vpc.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_1.id
}

resource "aws_route" "cluster_1_yba" {
  provider = aws.ap-northeast-1
  for_each = toset(module.cluster_vpc_1.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.yba_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_1.id
}

# VPC Peering YBA → Cluster2

resource "aws_vpc_peering_connection" "yba_cluster_2" {
  provider = aws.ap-northeast-1

  vpc_id      = module.yba_vpc.vpc_id
  peer_vpc_id = module.cluster_vpc_2.vpc_id
  peer_region = "us-east-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "yba_cluster_2" {
  provider = aws.us-east-1

  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_2.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "yba_cluster_2" {
  provider = aws.us-east-1

  vpc_peering_connection_id = local.yba_cluster_2_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "yba_cluster_2" {
  provider = aws.ap-northeast-1
  for_each = toset(module.yba_vpc.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_2.id
}

resource "aws_route" "cluster_2_yba" {
  provider = aws.us-east-1
  for_each = toset(module.cluster_vpc_2.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.yba_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_2.id
}

# VPC Peering YBA → Cluster3

resource "aws_vpc_peering_connection" "yba_cluster_3" {
  provider = aws.ap-northeast-1

  vpc_id      = module.yba_vpc.vpc_id
  peer_vpc_id = module.cluster_vpc_3.vpc_id
  peer_region = "eu-west-2"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "yba_cluster_3" {
  provider = aws.eu-west-2

  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_3.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "yba_cluster_3" {
  provider = aws.eu-west-2

  vpc_peering_connection_id = local.yba_cluster_3_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "yba_cluster_3" {
  provider = aws.ap-northeast-1
  for_each = toset(module.yba_vpc.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_3.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_3.id
}

resource "aws_route" "cluster_3_yba" {
  provider = aws.eu-west-2
  for_each = toset(module.cluster_vpc_3.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.yba_vpc.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.yba_cluster_3.id
}

# VPC Peering Cluster1 → Cluster2

resource "aws_vpc_peering_connection" "cluster_1_cluster_2" {
  provider = aws.ap-northeast-1

  vpc_id      = module.cluster_vpc_1.vpc_id
  peer_vpc_id = module.cluster_vpc_2.vpc_id
  peer_region = "us-east-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "cluster_1_cluster_2" {
  provider = aws.us-east-1

  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_1_cluster_2.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "cluster_1_cluster_2" {
  provider = aws.us-east-1

  vpc_peering_connection_id = local.cluster_1_cluster_2_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "cluster_1_cluster_2" {
  provider = aws.ap-northeast-1
  for_each = toset(module.cluster_vpc_1.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_1_cluster_2.id
}

resource "aws_route" "cluster_2_cluster_1" {
  provider = aws.us-east-1
  for_each = toset(module.cluster_vpc_2.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_1_cluster_2.id
}

# VPC Peering Cluster2 → Cluster3

resource "aws_vpc_peering_connection" "cluster_2_cluster_3" {
  provider = aws.us-east-1

  vpc_id      = module.cluster_vpc_2.vpc_id
  peer_vpc_id = module.cluster_vpc_3.vpc_id
  peer_region = "eu-west-2"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "cluster_2_cluster_3" {
  provider = aws.eu-west-2

  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_2_cluster_3.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "cluster_2_cluster_3" {
  provider = aws.eu-west-2

  vpc_peering_connection_id = local.cluster_2_cluster_3_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "cluster_2_cluster_3" {
  provider = aws.us-east-1
  for_each = toset(module.cluster_vpc_2.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_3.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_2_cluster_3.id
}

resource "aws_route" "cluster_3_cluster_2" {
  provider = aws.eu-west-2
  for_each = toset(module.cluster_vpc_3.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_2.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_2_cluster_3.id
}

# VPC Peering Cluster3 → Cluster1

resource "aws_vpc_peering_connection" "cluster_3_cluster_1" {
  provider = aws.eu-west-2

  vpc_id      = module.cluster_vpc_3.vpc_id
  peer_vpc_id = module.cluster_vpc_1.vpc_id
  peer_region = "ap-northeast-1"
  auto_accept = false
}

resource "aws_vpc_peering_connection_accepter" "cluster_3_cluster_1" {
  provider = aws.ap-northeast-1

  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_3_cluster_1.id
  auto_accept               = true
}

resource "aws_vpc_peering_connection_options" "cluster_3_cluster_1" {
  provider = aws.ap-northeast-1

  vpc_peering_connection_id = local.cluster_3_cluster_1_vpc_peering_connection_id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "cluster_3_cluster_1" {
  provider = aws.eu-west-2
  for_each = toset(module.cluster_vpc_3.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_1.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_3_cluster_1.id
}

resource "aws_route" "cluster_1_cluster_3" {
  provider = aws.ap-northeast-1
  for_each = toset(module.cluster_vpc_1.public_route_table_ids)

  route_table_id            = each.key
  destination_cidr_block    = module.cluster_vpc_3.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.cluster_3_cluster_1.id
}

# Security Groups

module "yba_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  providers = {
    aws = aws.ap-northeast-1
  }

  name        = "yba"
  description = "yba"
  vpc_id      = module.yba_vpc.vpc_id

  ingress_cidr_blocks = [
    module.yba_vpc.vpc_cidr_block,
    module.cluster_vpc_1.vpc_cidr_block,
    module.cluster_vpc_2.vpc_cidr_block,
    module.cluster_vpc_3.vpc_cidr_block,
    "159.28.69.102/32" # Tagbangers, Inc.
  ]
  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
}

module "cluster_1_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  providers = {
    aws = aws.ap-northeast-1
  }

  name        = "yb-cluster-1"
  description = "yb-cluster-1"
  vpc_id      = module.cluster_vpc_1.vpc_id

  ingress_cidr_blocks = [
    module.yba_vpc.vpc_cidr_block,
    module.cluster_vpc_1.vpc_cidr_block,
    module.cluster_vpc_2.vpc_cidr_block,
    module.cluster_vpc_3.vpc_cidr_block,
  ]
  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
}

module "cluster_2_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  providers = {
    aws = aws.us-east-1
  }

  name        = "yb-cluster-2"
  description = "yb-cluster-2"
  vpc_id      = module.cluster_vpc_2.vpc_id

  ingress_cidr_blocks = [
    module.yba_vpc.vpc_cidr_block,
    module.cluster_vpc_1.vpc_cidr_block,
    module.cluster_vpc_2.vpc_cidr_block,
    module.cluster_vpc_3.vpc_cidr_block,
  ]
  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
}

module "cluster_3_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  providers = {
    aws = aws.eu-west-2
  }

  name        = "yb-cluster-3"
  description = "yb-cluster-3"
  vpc_id      = module.cluster_vpc_3.vpc_id

  ingress_cidr_blocks = [
    module.yba_vpc.vpc_cidr_block,
    module.cluster_vpc_1.vpc_cidr_block,
    module.cluster_vpc_2.vpc_cidr_block,
    module.cluster_vpc_3.vpc_cidr_block,
  ]
  ingress_rules = ["all-all"]
  egress_rules  = ["all-all"]
}

# EC2 for YBA

module "yba_key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  providers = {
    aws = aws.ap-northeast-1
  }

  key_name   = "yba"
  public_key = file("../.ssh/yba_rsa.pub")
}

module "yba_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix = "yba-"
  path        = "/"
  policy      = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Sid": "VisualEditor0",
           "Effect": "Allow",
           "Action": [
               "iam:PassRole",
               "ec2:AttachVolume",
               "ec2:AuthorizeSecurityGroupIngress",
               "ec2:ImportVolume",
               "ec2:ModifyVolumeAttribute",
               "ec2:DescribeInstances",
               "ec2:DescribeInstanceAttribute",
               "ec2:CreateKeyPair",
               "ec2:DescribeVolumesModifications",
               "ec2:DeleteVolume",
               "ec2:DescribeVolumeStatus",
               "ec2:StartInstances",
               "ec2:DescribeAvailabilityZones",
               "ec2:DescribeVolumes",
               "ec2:ModifyInstanceAttribute",
               "ec2:DescribeKeyPairs",
               "ec2:DescribeInstanceStatus",
               "ec2:DetachVolume",
               "ec2:ModifyVolume",
               "ec2:TerminateInstances",
               "ec2:AssignIpv6Addresses",
               "ec2:ImportKeyPair",
               "ec2:DescribeTags",
               "ec2:CreateTags",
               "ec2:RunInstances",
               "ec2:AssignPrivateIpAddresses",
               "ec2:StopInstances",
               "ec2:AllocateAddress",
               "ec2:DescribeVolumeAttribute",
               "ec2:DescribeSecurityGroups",
               "ec2:CreateVolume",
               "ec2:EnableVolumeIO",
               "ec2:DescribeImages",
               "ec2:DescribeVpcs",
               "ec2:DeleteSecurityGroup",
               "ec2:DescribeSubnets",
               "ec2:DeleteKeyPair",
               "ec2:DescribeVpcPeeringConnections",
               "ec2:DescribeRouteTables",
               "ec2:DescribeInternetGateways",
               "ec2:GetConsoleOutput",
               "ec2:CreateSnapshot",
               "ec2:DeleteSnapshot",
               "ec2:DescribeInstanceTypes"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

data "aws_ssm_parameter" "amazonlinux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_ssm_parameter" "amazonlinux_2_ap_northeast_1" {
  provider = aws.ap-northeast-1

  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "amazonlinux_2_us_east_1" {
  provider = aws.us-east-1

  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "amazonlinux_2_eu_west_2" {
  provider = aws.eu-west-2

  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# https://docs.yugabyte.com/preview/yugabyte-platform/prepare/server-yba/
# YugabyteDB Anywhere doesn't support ARM architectures (but can be used to deploy universes to ARM-based nodes).
module "yba_ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  providers = {
    aws = aws.ap-northeast-1
  }

  name          = "yba"
  instance_type = "t3.xlarge" # YBA requires 4 CPUs
  ami           = data.aws_ssm_parameter.amazonlinux_2023.value
  #   ami                         = "ami-0acb1113d6ebeeacc" # AlmaLinux 8 x86_64
  key_name                    = module.yba_key_pair.key_pair_name
  vpc_security_group_ids      = [module.yba_security_group.security_group_id]
  subnet_id                   = module.yba_vpc.public_subnets[0]
  associate_public_ip_address = true

  create_iam_instance_profile = true
  iam_role_policies = {
    YBAPolicy                    = module.yba_policy.arn
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 250 # YBA requires 200 GiB
    }
  ]
}

module "node_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role             = true
  create_instance_profile = true
  role_name               = "yb-node"
  role_requires_mfa       = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  trusted_role_services = [
    "ec2.amazonaws.com"
  ]
}