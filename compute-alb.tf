locals {
    user_data_b64 = base64encode(file("${path.module}/userdata.sh}"))
}

resource "aws_launch_template" "web" {
  name_prefix = "${var.project_name}-lt-"
  image_id = data.aws_ami.al2023.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name 
  }

  vpc_security_group_ids = [aws_security_group.web.id]
  user_data = local.user_data_b64
  tag_specifications {
    resource_type = "instance"
    tags = {
        Name = "${var.project_name}-web"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name = "${var.project_name}-asg"
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  vpc_zone_identifier = [for s in aws_subnet.private : s.id]
  health_check_type = "ELB"
  health_check_grace_period = 90
  launch_template {
    id = aws_launch_template.web.id 
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.http.arn]

  tag {
    key = "Name"
    value = "${var.project_name}-web"
    propagate_at_launch = true
  }
}

# Load Balancer
resource "aws_lb" "this" {
  name = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal = false 
  security_groups = [aws_security_group.alb.id]
  subnets = [for s in aws_subnet_public : s.id]
  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Load Balancer Target Group
resource "aws_lb_target_group" "http" {
  name = "${var.project_name}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.this.id 

  health_check {
    path = "/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 15
    timeout = 5
    matcher = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  } 
}