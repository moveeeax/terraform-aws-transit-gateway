output "id" {
  description = "ID of the transit gateway."
  value       = aws_ec2_transit_gateway.this.id
}

output "arn" {
  description = "ARN of the transit gateway."
  value       = aws_ec2_transit_gateway.this.arn
}

output "owner_id" {
  description = "AWS account ID that owns the transit gateway."
  value       = aws_ec2_transit_gateway.this.owner_id
}

output "association_default_route_table_id" {
  description = "ID of the default association route table."
  value       = aws_ec2_transit_gateway.this.association_default_route_table_id
}

output "propagation_default_route_table_id" {
  description = "ID of the default propagation route table."
  value       = aws_ec2_transit_gateway.this.propagation_default_route_table_id
}
