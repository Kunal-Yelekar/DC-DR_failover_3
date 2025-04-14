resource "aws_lb_target_group" "this" {
  name     = var.name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    protocol             = var.protocol
    port                 = var.port
    path                 = var.health_check_path
    healthy_threshold    = 3
    unhealthy_threshold  = 3
    interval             = 30
    timeout              = 5
  }

  tags = {
    Name = var.name
  }
}

output "tg_arn" {
  value = aws_lb_target_group.this.arn
}
