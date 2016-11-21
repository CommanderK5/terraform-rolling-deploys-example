# Rolling ELB
resource "aws_elb" "rolling_ELB" {
  name                      = "rolling-ELB"
  subnets                   = ["${aws_subnet.example.id}"]
  security_groups           = ["${aws_security_group.example.id}"]
  internal                    = false
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    target              = "HTTP:80/"
    interval            = 5
  }
}

resource "aws_launch_configuration" "rolling_LC" {
  name_prefix     = "rolling_LC-"
  image_id        = "${var.ami_id}"
  instance_type   = "t2.small"
  security_groups = ["${aws_security_group.example.id}"]
  user_data       = "${file("user_data/boot.sh")}"
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rolling_ASG" {
  name                      = "rolling_app_ASG-${aws_launch_configuration.rolling_LC.id}"
  availability_zones        = ["eu-central-1a"]
  vpc_zone_identifier       = ["${aws_subnet.example.id}"]
  launch_configuration      = "${aws_launch_configuration.rolling_LC.id}"
  load_balancers            = ["${aws_elb.rolling_ELB.id}"]
  health_check_grace_period = 60
  max_size                  = "1"
  min_size                  = "1"
  wait_for_elb_capacity     = true
  lifecycle {
      create_before_destroy = true
  }
  tag {
    key                 = "AMI"
    value               = "${var.ami_id}"
    propagate_at_launch = true
  }
}
