variable "project_name" {
  description = "Name Prefix for Resources"
  type = string
  default = "alb-private-ec2"
}

variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "us-west-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type = string
  default = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRs for 2 AZs"
  type = list(string)
  default = [ "10.20.0.0/24","10.20.1.0/24" ]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRs for 2 AZs"
  type = list(string)
  default = [ "10.20.10.0/24","10.20.11.0/24" ]
}

variable "desired_capacity" {
  description = "Auto-Scaling Group Desired Capacity"
  type = number
  default = 2
}

variable "min_size" {
  description = "Auto-Scaling Group Min. Size"
  type = number
  default = 2
}

variable "max_size" {
  description = "Auto-Scaling Group Max Size"
  type = number
  default = 4
}

