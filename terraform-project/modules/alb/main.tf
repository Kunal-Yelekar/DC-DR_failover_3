resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.sg_ids
  subnets            = var.subnets
  ip_address_type    = var.ip_address_type
  tags = {
    Name = var.name
  }
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "dns_name" {
  value = aws_lb.this.dns_name
}
