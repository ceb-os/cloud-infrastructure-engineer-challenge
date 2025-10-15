data "aws_kms_key" "kms-aws-rds" {
  key_id = "ed41829f-41c4-4885-98d4-d96dde08a7e2"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# para la customer managed policy
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "./function_code/"
  output_path = "./function_code/lambda_function.zip"
}