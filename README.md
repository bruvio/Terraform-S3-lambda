# Terraform module: S3 Triggered Lambda

## Overview

This repo is about creating an AWS Lambda function that will execute
when new images files (in jpg format) are dumped into an S3 bucket (i.e. bucket A or source bucket). 
The lambda will remove exif data from image and upload the image to another S3 bucket (i.e. bucket B or destination bucket) in the same path


Terraform will be used to deploy the solution. 
It also creates two users. User A can read/write to bucket A and User B can read from Bucket B.




The packaging of lambda.zip needs to be done manually. To create lambda.zip follow these steps:
```bash
pip3 install --target ./package exif
cd package
zip -r ../lambda.zip .
cd ..
zip -g lambda.zip lambda_function.py
mv lambda.zip ./terraform
```

or just run 
`./package_lambda.sh`

![AWS-architecture](terraform/AWS-architecture.png?raw=true)

Requires
- [poetry](https://python-poetry.org/docs/)
- [docker](https://docs.docker.com/get-docker/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [AWS account](https://aws.amazon.com/resources/create-account/)



## Content

* root module - Terraform module to setup S3 bucket, Lambda function and various
IAM roles and policies for the trigger to work and have access to the bucket
* terraform folder - a sample Terraform configuration that shows how to use this
module.
* lambda_function.py - a sample Python implementation of a lambda
function that reads/writes from/to the S3 bucket
* pyproject.toml - Poetry control file containing Python libraries needed for this to work



## Deployment




Before running Terraform and deploy to AWS it is necessary to store as env variables AWS credentials.
I choose to use [aws-vault](https://github.com/99designs/aws-vault) as provides additional security creating ephemeral credentials that last maximum 12h.

In my case I will run

`aws-vault exec <myuser> --duration=12h`

or you can choose to export
```
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}
```


In order to deploy this sample, you first need to initialize the working
directory:

`$ docker-compose -f terraform/docker-compose.yml run --rm terrafrom init`

Once initialize, you create and review the execution plan:

`$ docker-compose -f terraform/docker-compose.yml run --rm terrafrom plan`

If everything checks out, you can proceed with your deployment:

`$ docker-compose -f terraform/docker-compose.yml run --rm terraform apply`

To make life easy in the repo there is a makefile with some alias to run terraform commands.
Without going into the details.
The users has to create a workspace (dev, staging, prod ...), initialize, plan and apply.


## Future Enhancements

Convert this root module into a configurable module.


Make the lambda runtime configurable via a variable.
