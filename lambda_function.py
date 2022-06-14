import json
import boto3
from exif import Image
import os


s3_client = boto3.client("s3")


def remove_exif(image_file):
    image = Image(image_file)
    if image.has_exif:
        image.delete_all()
    return image.get_file()


def lambda_handler(event, context):
    destination_bucket_name = os.environ.get('DST_BUCKET')
    print('destination bucket name ' + destination_bucket_name)
    source_bucket_name = event['Records'][0]['s3']['bucket']['name']
    print('source_bucket_name ' + source_bucket_name)
    file_key_name = event['Records'][0]['s3']['object']['key']
    print('file_key_name ' + file_key_name)
    image_file = s3_client.get_object(Bucket=source_bucket_name,
                                      Key=file_key_name)['Body'].read()

    image = remove_exif(image_file)

    s3_client.put_object(Bucket=destination_bucket_name,
                         Key=file_key_name,
                         Body=image)

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
