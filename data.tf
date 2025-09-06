# Linux 2023 AMI (x86_64)
data "aws_ami" "al2023" {
  most_recent = true
  owners = ["137112412989"]
  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# 2 Availability Zones
data "aws_availability_zones" "available" {
  state = available
}