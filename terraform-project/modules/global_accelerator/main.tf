resource "aws_globalaccelerator_accelerator" "this" {
  name            = var.accelerator_name
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }
}

resource "aws_globalaccelerator_listener" "this" {
  accelerator_arn = aws_globalaccelerator_accelerator.this.id

  port_range {
    from_port = var.global_accelerator_listener_port
    to_port   = var.global_accelerator_listener_port
  }
  protocol = var.global_accelerator_protocol
}

resource "aws_globalaccelerator_endpoint_group" "this" {
  listener_arn                  = aws_globalaccelerator_listener.this.id
  health_check_interval_seconds = var.health_check_interval
  threshold_count               = var.endpoint_threshold_count

  endpoint_configuration {
    endpoint_id                    = var.endpoint_alb_dc
    weight                         = var.dc_weight
    client_ip_preservation_enabled = true
  }

  endpoint_configuration {
    endpoint_id                    = var.endpoint_alb_dr
    weight                         = var.dr_weight
    client_ip_preservation_enabled = true
  }
}
