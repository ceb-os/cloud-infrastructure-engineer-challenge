# se crea la api
resource "aws_api_gateway_rest_api" "apigw" {
  name = "nanlabs-apigw-rest-api"
  description = "API GW that will trigger the nanlabs-lambda-function"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# se crea el recurso info (parent_id = /)
resource "aws_api_gateway_resource" "info_resource" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  path_part   = "info" 
}

# se crea el GET method
resource "aws_api_gateway_method" "info_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.info_resource.id
  http_method   = "GET"
  authorization = "NONE" 
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.info_resource.id
  http_method             = aws_api_gateway_method.info_get_method.http_method
  passthrough_behavior    = "WHEN_NO_MATCH"
  
  # Type AWS_PROXY is the standard for Lambda integration
  type                    = "NONE"
  
  # por algun motivo es POST inclusive para GET
  integration_http_method = "POST" 
  
  # Use the Lambda's ARN to define the target
  uri                     = aws_lambda_function.lambda.invoke_arn 
}

resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # Source ARN restricts which API Gateway can invoke the function
  source_arn = "${aws_api_gateway_rest_api.apigw.execution_arn}/*/${aws_api_gateway_method.info_get_method.http_method}${aws_api_gateway_resource.info_resource.path}"
}

resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  
  # Triggers ensure a *new* deployment is created when *any* related config changes
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.info_resource.id,
      aws_api_gateway_method.info_get_method.id,
      aws_api_gateway_integration.lambda_integration.id,
    ]))
  }
  
  # Best practice to avoid downtime during replacement
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.apigw_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  stage_name    = "v1"
}

# Corrected Output Block
output "invoke_url" {
  value = "${aws_api_gateway_stage.stage.invoke_url}${aws_api_gateway_resource.info_resource.path}"
  description = "The callable URL for the /info GET endpoint."
}