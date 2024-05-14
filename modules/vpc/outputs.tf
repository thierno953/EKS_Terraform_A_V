output "vpc_id" {
  value = aws_vpc.tfVPC.id
}

output "public_subnets" {
  description = "Will be used by Web Server Module to set subnet_ids"
  value = [
    aws_subnet.tfPublicSubnet1,
    aws_subnet.tfPublicSubnet2
  ]
}

output "private_subnets" {
  description = "Will be used by RDS Module to set subnet_ids"
  value = [
    aws_subnet.tfPrivateSubnet1,
    aws_subnet.tfPrivateSubnet2
  ]
}
