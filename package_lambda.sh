#!/bin/bash
set -e
pip3 install --target ./package exif --upgrade
cd package
zip -r ../lambda.zip .
cd ..
zip -g lambda.zip lambda_function.py
mv lambda.zip ./terraform