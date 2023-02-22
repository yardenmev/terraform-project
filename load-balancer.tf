resource "aws_security_group" "lb-sg" {
  name   = "yarden-lb-SG"
  vpc_id = aws_vpc.main.id
  ingress {
    description = "80 to LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    description     = "trafic to lb"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "yarden-lb-SG-tf"
  }
}
resource "aws_lb" "yarden-lb" {
  
  name               = "yarden-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]
  subnets            = [for subnets in aws_subnet.subnets : subnets.id]

  # enable_deletion_protection = true


  tags = {
    Name = "yarden-lb"
  }
}
resource "aws_lb_listener" "ec2" {
  load_balancer_arn = aws_lb.yarden-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}
resource "aws_lb_target_group" "TG" {
  name     = "yarden-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
resource "aws_lb_target_group_attachment" "tg" {
  count = var.ec2
  target_group_arn = aws_lb_target_group.TG.arn
  target_id        = aws_instance.yarden-ec2[count.index].id
  port             = 80
}
