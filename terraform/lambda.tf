resource "aws_lambda_function" "my_lambda_function" {
  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  function_name    = "${var.prefix}_my_lambda"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-lambda" })
  )

  environment {
    variables = {
      DST_BUCKET = aws_s3_bucket.destination_bucket.id
    }
  }
}
