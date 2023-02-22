output "instance1_ip_addr" {
  value = aws_instance.yarden-ec2-1.public_ip
}
output "instance2_ip_addr" {
  value = aws_instance.yarden-ec2-2.public_ip
}
output "instance_Key" {
  value = var.key_name
}
output "load_balancer_DNS" {
  value = aws_lb.yarden-lb.dns_name
}

