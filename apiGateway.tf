## Create the API Gateway HTTP endpoint
#resource "aws_api_gateway_rest_api" "aws_api_gateway_rest_api" {
#  name          = "registro-ponto-gateway_rest_api"
#}
#
#resource "aws_api_gateway_resource" "aws_api_gateway_resource" {
#  rest_api_id = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
#  parent_id   = aws_api_gateway_rest_api.aws_api_gateway_rest_api.root_resource_id
#  path_part   = "registro-ponto"
#}
#
#resource "aws_api_gateway_method" "aws_api_gateway_method" {
#  rest_api_id   = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
#  resource_id   = aws_api_gateway_resource.aws_api_gateway_resource.id
#  http_method   = "ANY"
#  authorization = "NONE"
#}
#
#resource "aws_api_gateway_vpc_link" "vpc_link" {
#  name        = "my-vpc-link"
#  description = "VPC Link for API Gateway"
#  target_arns = [aws_lb.ecs_alb.arn]
#}
#
#resource "aws_api_gateway_integration" "aws_api_gateway_integration" {
#  rest_api_id             = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
#  resource_id             = aws_api_gateway_resource.aws_api_gateway_resource.id
#  http_method             = aws_api_gateway_method.aws_api_gateway_method.http_method
#  type                    = "HTTP_PROXY"
#  integration_http_method = "ANY"
#  uri                     = "http://${aws_lb.ecs_alb.dns_name}"
#  connection_type         = "VPC_LINK"
#  connection_id           = aws_api_gateway_vpc_link.vpc_link.id
#}
#
#resource "aws_api_gateway_deployment" "aws_api_gateway_deployment" {
#  depends_on = [aws_api_gateway_integration.aws_api_gateway_integration]
#  rest_api_id = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
#  stage_name = "prod"
#}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "my-api"
  description = "My API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "my-resource"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS" # Isso será alterado para "AWS" quando integrar com o ECS
}

resource "aws_api_gateway_method_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.proxy.status_code
}

resource "aws_api_gateway_vpc_link" "my_vpc_link" {
  name        = "my-vpc-link"
  target_arns = [aws_lb.ecs_alb.arn] # Substitua pelo ARN do seu Load Balancer do ECS
}

resource "aws_api_gateway_integration" "ecs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.ecs_alb.dns_name}/mypath" # Substitua pelo endereço do seu ECS
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.my_vpc_link.id
}
