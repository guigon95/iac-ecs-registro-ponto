resource "aws_ecr_repository" "registro-ponto" {
  name                 = "registro-ponto"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}