output "alb_dns_name" {
  description = "Public DNS Name of ALB"
  value = aws_lb.this.dns_name
}

output "vpc_id" {
    value = aws_vpc.this.id 
}

