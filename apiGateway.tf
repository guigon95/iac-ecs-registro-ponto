# Create the API Gateway HTTP endpoint
resource "aws_api_gateway_rest_api" "aws_api_gateway_rest_api" {
  name          = "registro-ponto-pvt-endpoint"
}

resource "aws_api_gateway_resource" "aws_api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
  parent_id   = aws_api_gateway_rest_api.aws_api_gateway_rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "aws_api_gateway_method" {
  rest_api_id   = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.aws_api_gateway_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "aws_api_gateway_integration" {
  rest_api_id             = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
  resource_id             = aws_api_gateway_resource.aws_api_gateway_resource.id
  http_method             = aws_api_gateway_method.aws_api_gateway_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.example.dns_name}/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_deployment" "aws_api_gateway_deployment" {
  depends_on = [aws_api_gateway_integration.aws_api_gateway_integration]
  rest_api_id = aws_api_gateway_rest_api.aws_api_gateway_rest_api.id
  stage_name = "prod"
}