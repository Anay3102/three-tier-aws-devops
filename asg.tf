
# AUTO SCALING GROUP


resource "aws_autoscaling_group" "app" {

  name = "${var.project_name}-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 4


  vpc_zone_identifier = [
    aws_subnet.private_app_1.id,
    aws_subnet.private_app_2.id
  ]


  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  health_check_type = "ELB"

  health_check_grace_period = 180

  # Launch Template
  launch_template {
    id = aws_launch_template.app.id

    version = "$Latest"
  }


  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-server"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "production"
    propagate_at_launch = true
  }
}



# SCALE UP POLICY

resource "aws_autoscaling_policy" "scale_up" {

  name = "${var.project_name}-scale-up"

  autoscaling_group_name = aws_autoscaling_group.app.name

  adjustment_type = "ChangeInCapacity"

  scaling_adjustment = 1

  cooldown = 300

  policy_type = "SimpleScaling"
}



# SCALE DOWN POLICY


resource "aws_autoscaling_policy" "scale_down" {

  name = "${var.project_name}-scale-down"

  autoscaling_group_name = aws_autoscaling_group.app.name

  adjustment_type = "ChangeInCapacity"

  scaling_adjustment = -1

  cooldown = 300

  policy_type = "SimpleScaling"
}



# CPU ALARM - SCALE UP


resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "${var.project_name}-high-cpu"

  alarm_description = "Scale up when average EC2 CPU is high"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 120

  statistic = "Average"

  threshold = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up.arn
  ]
}



# CPU ALARM - SCALE DOWN


resource "aws_cloudwatch_metric_alarm" "low_cpu" {

  alarm_name = "${var.project_name}-low-cpu"

  alarm_description = "Scale down when average EC2 CPU is low"

  comparison_operator = "LessThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 120

  statistic = "Average"

  threshold = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down.arn
  ]
}