output "accelerator_arn" {
  value = aws_globalaccelerator_accelerator.this.arn
}

output "accelerator_dns_name" {
  value = aws_globalaccelerator_accelerator.this.dns_name
}
