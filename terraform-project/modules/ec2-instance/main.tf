resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_ids
  associate_public_ip_address = true

  tags = {
    Name = var.name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}
