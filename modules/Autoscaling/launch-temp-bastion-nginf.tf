/*# Launch template for bastion

resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami-web
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]

  iam_instance_profile {
    name = "aws_iam_instance_profile.ip.id"
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "bastion-launch-template"
    }
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

# launch template for nginx
# path.module helps you determines the current working directory

resource "aws_launch_template" "nginx-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  iam_instance_profile {
    name = "aws_iam_instance_profile.ip.id"
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "nginx-launch-template"
    }
  }

  user_data = filebase64("${path.module}/nginx.sh")
}*/
