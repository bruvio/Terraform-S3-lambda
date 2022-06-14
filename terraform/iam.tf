

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.prefix}_lambda_policy"
  description = "${var.prefix}_lambda_policy"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-iam-lambda" })
  )

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:CopyObject",
        "s3:HeadObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "app_${var.prefix}_lambda"
  tags = {
    name = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "my_iam_policy_basic_execution" {
  role       = aws_iam_role.lambda_iam_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_permission" "allow_lambda_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_bucket.arn
}

resource "aws_iam_user" "usera" {
  name = "usera"
  force_destroy = true

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-iam-usera" })
  )
}

resource "aws_iam_user_policy" "usera_policy" {
  name = "usera"
  user = aws_iam_user.usera.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:*Object"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.source_bucket.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_user" "userb" {
  name = "userb"
  force_destroy = true

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-iam-userb" })
  )
}

resource "aws_iam_user_policy" "userb_policy" {
  name = "userb"
  user = aws_iam_user.userb.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.destination_bucket.arn}"
    }
  ]
}
EOF
}
