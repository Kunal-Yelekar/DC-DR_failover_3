resource "aws_instance" "this" {
  count                   = var.instance_count
  ami                     = var.ami
  instance_type           = var.instance_type
  subnet_id               = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids  = var.security_group_ids

  tags = merge(var.tags, {
    Name = "${var.environment}-ec2-${count.index + 1}"
  })
}
