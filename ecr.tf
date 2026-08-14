
# AMAZON ECR REPOSITORY

resource "aws_ecr_repository" "node_app" {
  name                 = "three-tier-node-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-ecr"
  }
}



# ECR LIFECYCLE POLICY


resource "aws_ecr_lifecycle_policy" "node_app" {

  repository = aws_ecr_repository.node_app.name

  policy = jsonencode({

    rules = [

      {
        rulePriority = 1

        description = "Keep only the latest 10 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }

        action = {
          type = "expire"
        }
      }

    ]

  })
}