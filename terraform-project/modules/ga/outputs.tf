output "accelerator_arn" {
  description = "ARN of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.arn
}

output "accelerator_name" {
  description = "Name of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.name
}

output "accelerator_dns_name" {
  description = "DNS name of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.dns_name
}
