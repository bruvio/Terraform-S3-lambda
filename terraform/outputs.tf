output "bucket-source-A" {
  value = aws_s3_bucket.source_bucket.id
}
output "bucket-destination-B" {
  value = aws_s3_bucket.destination_bucket.id
}

output "bucket-A-arn" {
  value = aws_s3_bucket.source_bucket.arn
}
output "bucket-B-arn" {
  value = aws_s3_bucket.destination_bucket.arn
}
output "lambda_function_arn" {
  value = "${aws_lambda_function.my_lambda_function.arn}"
}
output "lambda_iam_role" {
  value = "${aws_iam_role.lambda_iam_role.arn}"
}

