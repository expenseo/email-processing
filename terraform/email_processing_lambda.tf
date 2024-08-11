resource "aws_lambda_function" "email_processing_lambda" {
  filename         = local.build_file_name
  function_name    = "email-processing-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "src/index.handler"
  runtime          = "nodejs20.x"
  source_code_hash = data.archive_file.build_zip.output_base64sha256
}

resource "aws_iam_role_policy_attachment" "email_processing_lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_permission" "email_processing_execution_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_processing_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.email_processing_api_rest.execution_arn}/*/*/*}/*"
}
