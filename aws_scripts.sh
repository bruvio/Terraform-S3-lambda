#!/bin/bash
set -e

destination bucket name
AWS_REGION="us-east-1"
accountid=$(aws sts get-caller-identity --query Account --output text)


project_name='tf-s3-triggered-lambda-module'
bucket_name='bruvio-tfstate-'$project_name

table_name='terraform-setup-tf-state-lock-'$project_name
table_primary_key='LockID'





aws s3api create-bucket --bucket $bucket_name || echo "\n bucket $bucket_name already exists"

echo "\n  Creating S3 bucket to store Terraform state"

aws s3api put-bucket-versioning --bucket $bucket_name --versioning-configuration Status=Enabled

aws s3 mb s3://$bucket_name --region us-east-1 && \
aws s3api put-bucket-versioning --bucket $bucket_name --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption \
--bucket $bucket_name \
--server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

echo "\n bucket created"

echo "\n creating Dynamodb table"

aws dynamodb create-table --table-name $table_name \
    --attribute-definitions AttributeName=$table_primary_key,AttributeType=S \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --key-schema AttributeName=$table_primary_key,KeyType=HASH --region us-east-1 || echo "\n dynamoDB table $table_name already exists"

