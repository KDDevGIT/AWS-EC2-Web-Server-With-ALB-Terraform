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

