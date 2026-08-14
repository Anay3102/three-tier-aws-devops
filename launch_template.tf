
# AMAZON LINUX 2023 AMI


data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}



# EC2 LAUNCH TEMPLATE


resource "aws_launch_template" "app" {

  name = "${var.project_name}-app-template"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  user_data = base64encode(
    templatefile("${path.module}/userdata.sh", {
      aws_region     = var.aws_region
      ecr_repository = aws_ecr_repository.node_app.name
    })
  )

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-app-server"
    }
  }

  tags = {
    Name = "${var.project_name}-launch-template"
  }
}