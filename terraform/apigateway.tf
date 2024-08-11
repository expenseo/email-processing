resource "aws_api_gateway_rest_api" "email_processing_api_rest" {
  name        = "email-processing-expenseo"
  description = "API Gateway for receive email notifications from Bank"
}

resource "aws_api_gateway_resource" "email_processing_resource" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest
  parent_id   = aws_api_gateway_rest_api.email_processing_api_rest.root_resource_id
  path_part   = "email-process"
}

resource "aws_api_gateway_method" "email_processing_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id   = aws_api_gateway_resource.email_processing_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "email_processing_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id             = aws_api_gateway_resource.email_processing_resource.id
  http_method             = aws_api_gateway_method.email_processing_method.http_method
  integration_http_method = "POST"
  type                    = "MOCK"
}

resource "aws_api_gateway_method_response" "email_process_api_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.email_processing_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "email_processing_lambda_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.email_processing_method.http_method
  status_code = aws_api_gateway_method_response.email_process_api_response.status_code

  depends_on = [
    aws_api_gateway_method.email_processing_method,
    aws_api_gateway_integration.email_processing_lambda
  ]
}

# TODO: Create OPTIONS request

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.email_processing_lambda]

  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  stage_name  = "dev"
}
