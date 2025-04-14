output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

# For simplicity, we return the single route table’s id here.
output "route_table_ids" {
  value = [aws_route_table.public.id]
}
