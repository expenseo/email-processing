resource "aws_api_gateway_rest_api" "email_processing" {
  name        = "email-processing-expenseo"
  description = "API Gateway for receive email notifications from Bank"
}

resource "aws_api_gateway_resource" "email_processing_resource" {
  rest_api_id = aws_api_gateway_rest_api.email_processing.id
  parent_id   = aws_api_gateway_rest_api.email_processing.root_resource_id
  path_part   = "test"
}
