import boto3
import json
from botocore.exceptions import ClientError
from datetime import datetime

def send_email(sender_email, recipient_email, event):
    subject = 'Terraform State File has been changed'
    body = f'time of change in Terraform state: {datetime.now()}.\n\nObject URL: {event["Records"][0]["s3"]["object"]["key"]}'

    ses_client = boto3.client('ses')

    try:
        response = ses_client.send_email(
            Source=sender_email,
            Destination={
                'ToAddresses': [recipient_email]
            },
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': body}}
            }
        )
        print("Email sent! Message ID:", response['MessageId'])
        return {
            'statusCode': 200,
            'body': 'Email sent successfully!'
        }
    except ClientError as e:
        print("Error sending email:", e.response['Error']['Message'])
        return {
            'statusCode': 500,
            'body': 'Error sending email'
        }

# Lambda function handler
def handler(event, context):

    sender_email = 'doaa.gamal.darwiish@gmail.com'
    recipient_email = 'doaa.gamal.darwiish@gmail.com'
    
    return send_email(sender_email, recipient_email, event)
