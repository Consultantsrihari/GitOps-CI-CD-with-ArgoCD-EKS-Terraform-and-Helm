terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "~> 5.31"
        }
    }
}

provider "aws" {
    region = var.aws_region
    access_key = "AKIAVEPEMGGSXSJWLS6B"
    secret_key = "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"
}


# Create an ECR repository to store our application's Docker image
resource "aws_ecr_repository" "app_ecr_repo" {
    name                 = "${var.app_name}-repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}