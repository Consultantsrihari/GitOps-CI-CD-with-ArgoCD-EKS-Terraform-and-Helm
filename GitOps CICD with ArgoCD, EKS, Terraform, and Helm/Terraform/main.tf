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
    access_key = "your access key"
    secret_key = "your secret key"
}


# Create an ECR repository to store our application's Docker image
resource "aws_ecr_repository" "app_ecr_repo" {
    name                 = "${var.app_name}-repo"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }

}
