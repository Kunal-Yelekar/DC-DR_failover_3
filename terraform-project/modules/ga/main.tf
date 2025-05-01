resource "aws_globalaccelerator_accelerator" "this" {
  name            = "${var.environment}-ga"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }
}

resource "aws_globalaccelerator_listener" "this" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id
  protocol        = var.ga_listener_protocol

  port_range {
    from_port = var.ga_listener_port
    to_port   = var.ga_listener_port
  }
}

resource "aws_globalaccelerator_endpoint_group" "this" {
  listener_arn            = aws_globalaccelerator_listener.this.arn
  endpoint_group_region   = var.region

  endpoint_configuration {
    endpoint_id = var.dc_alb_arn
    weight      = 128
  }

  endpoint_configuration {
    endpoint_id = var.dr_alb_arn
    weight      = 128
  }

  health_check_interval_seconds = 30
  health_check_path             = "/"
  health_check_port             = var.ga_health_check_port
  health_check_protocol         = var.ga_health_check_protocol
  threshold_count             = 3
}
