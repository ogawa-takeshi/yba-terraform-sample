# Deploying YugabyteDB Universe w/ YugabyteDB Anywhere Terraform Module

```
mkdir .ssh
ssh-keygen -t rsa -f .ssh/yba_rsa
```

```
terraform apply -target module.yba_vpc
terraform apply -target module.cluster_vpc_1
terraform apply -target module.cluster_vpc_2
terraform apply -target module.cluster_vpc_3
terraform apply
```

```
ssh -i .ssh/yba_rsa ec2-user@13.113.15.64
```

```
sudo update-alternatives --install /usr/local/bin/python python \
/usr/bin/python2.7 2

sudo update-alternatives --install /usr/local/bin/python python \
/usr/bin/python3.7 3
```



https://registry.terraform.io/providers/yugabyte/yba/latest/docs/resources/cloud_provider

1. IAM User or IAM Role
2. VPC
3. Subnet
4. Security Group

Jinja  
https://developer.hashicorp.com/terraform/tutorials/aws/aws-control-tower-aft