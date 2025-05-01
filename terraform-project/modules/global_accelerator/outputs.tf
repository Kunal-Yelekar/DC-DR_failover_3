output "accelerator_id" {
  value = aws_globalaccelerator_accelerator.this.id
}
output "accelerator_dns" {
  value = aws_globalaccelerator_accelerator.this.dns_name
}
