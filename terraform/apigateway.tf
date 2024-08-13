resource "aws_api_gateway_rest_api" "email_processing_api_rest" {
  name        = "email-processing-expenseo"
  description = "API Gateway for receive email notifications from Bank"
}

resource "aws_api_gateway_resource" "email_processing_resource" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  parent_id   = aws_api_gateway_rest_api.email_processing_api_rest.root_resource_id
  path_part   = "process-email"
}

# POST METHOD
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id   = aws_api_gateway_resource.email_processing_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_method_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id             = aws_api_gateway_resource.email_processing_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.email_processing_lambda.invoke_arn
}

resource "aws_api_gateway_method_response" "post_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "post_method_lambda_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.post_response.status_code

  depends_on = [
    aws_api_gateway_method.post_method,
    aws_api_gateway_integration.post_method_lambda_integration
  ]
}

# OPTIONS METHOD
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id   = aws_api_gateway_resource.email_processing_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id             = aws_api_gateway_resource.email_processing_resource.id
  http_method             = aws_api_gateway_method.options_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  resource_id = aws_api_gateway_resource.email_processing_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_method_response.status_code

  depends_on = [
    aws_api_gateway_method.options_method
  ]
}


resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.post_method_lambda_integration,
    aws_api_gateway_integration.options_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.email_processing_api_rest.id
  stage_name  = "dev"
}
