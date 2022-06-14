



resource "aws_s3_bucket" "source_bucket" {
  bucket        = "${var.prefix}-bucket-a"
  force_destroy = true

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bucket-a" })
  )
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket        = "${var.prefix}-bucket-b"
  force_destroy = true


    
  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bucket-b" })
  )
}

resource "aws_s3_bucket_notification" "bucket_terraform_notification" {
  bucket = aws_s3_bucket.source_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_lambda_bucket]
}

