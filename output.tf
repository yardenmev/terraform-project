output "instance_ip_addr" {
  value = [for value in aws_instance.yarden-ec2 : "instance name: ${value.tags.Name} instance IP: ${value.public_ip}"]
}

output "instance_Key" {
  value = var.key_name
}

output "load_balancer_DNS" {
  value = aws_lb.yarden-lb.dns_name
}

