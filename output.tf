output "vpc_id" {

  value = aws_vpc.main.id
}

output "vpc_cidr" {

  value = aws_vpc.main.cidr_block
}

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.node_app.repository_url
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.app.dns_name
}