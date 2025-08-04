output "cluster_name" {
    description = "Amazon EKS Cluster name"
    value       = module.eks.cluster_name
}

output "cluster_endpoint" {
    description = "Endpoint for EKS control plane"
    value       = module.eks.cluster_endpoint
}

output "ecr_repository_url" {
    description = "URL of the ECR repository"
    value       = aws_ecr_repository.app_ecr_repo.repository_url
}

output "aws_region" {
    description = "AWS region where the infrastructure is deployed"
    value       = var.aws_region
}

output "guestbook_sa_role_arn" {
    description = "ARN of the IAM role for the guestbook service account"
    value       = module.iam_assumable_role_for_sa.iam_role_arn
}