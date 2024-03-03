# I am using aws Credentials through Env Variables.
#
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}

#=========================== Application Load Balancer        =========================
#=========================== Target Groups and its Listeners  =========================
resource "aws_lb" "my-alb" {
  name               = "name-of-my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-my-alb.id]
  subnets            = ["subnet-0ead290756c58a4e6", "subnet-06cd3529110629154", "subnet-0bb6ca5314094f18c"]
}

resource "aws_lb_target_group" "tg-my-alb" {
  name     = "name-of-tg-my-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0bce0fffa30b63817"
}

resource "aws_lb_listener" "my-alb-listener" {
  load_balancer_arn = aws_lb.my-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-my-alb.arn
  }
}
#===================================== Launch Template ================================
resource "aws_launch_template" "my-launch-template" {
  name_prefix   = "name-of-my-launch-template"
  image_id      = "ami-0ef9e689241f0bb6e"
  instance_type = "t2.micro"
  user_data     = filebase64("bash-for-web.sh") # located in Working Dir.


  network_interfaces {
    associate_public_ip_address = true
    #subnet_id                   = aws_subnet.sh_subnet_2.id
    security_groups = [aws_security_group.sg-for-ec2.id]
  }
}
#===================================== Autoscaling Group    =============================
#===================================== with Launch Template =============================
resource "aws_autoscaling_group" "my-asg" {
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  target_group_arns = [aws_lb_target_group.tg-my-alb.arn]

  launch_template {
    id      = aws_launch_template.my-launch-template.id
    version = "$Latest"
  }
}

#============================    Security Groups ================================
#============================ For ALB and EC2 (Luanch Template) =================
resource "aws_security_group" "sg-my-alb" {
  name   = "name-of-sg-my-alb"
  vpc_id = "vpc-0bce0fffa30b63817"

  ingress {
    description      = "Allow http request from anywhere"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow LoadBalancer eggress to all ports,protocols and IPv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "sg-for-ec2" {
  name   = "name-of-sg-for-ec2"
  vpc_id = "vpc-0bce0fffa30b63817"

  ingress {
    description     = "Allow http request from Load Balancer to ec2"
    protocol        = "tcp"
    from_port       = 80 # range of
    to_port         = 80 # port numbers
    security_groups = [aws_security_group.sg-my-alb.id]
  }


  egress {
    description = "Allow ec2 egress to all ports,protocols and IPv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


