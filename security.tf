# Security Group, ALB
resource "aws_security_group" "alb" {
  name = "${var.project_name}-alb-sg"
  description = "Application Load Balancer Security Group"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "HTTP from any destination"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

# EC2 Security Group (Allow Port 80 only from ALB SG)
resource "aws_security_group" "web" {
  name = "${var.project_name}-web-sg"
  description = "Security Group for Web Instances"
  vpc_id = aws_vpc.this.id 

  ingress {
    description = "HTTP from ALB Security Group"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}
