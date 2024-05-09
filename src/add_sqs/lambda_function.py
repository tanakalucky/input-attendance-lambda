import json
import boto3


def lambda_handler(event, context):
    try:
        target_year = event["arguments"]["targetYear"]
        target_month = event["arguments"]["targetMonth"]

        ssm = boto3.client("ssm", region_name="ap-northeast-1")

        queue_url = ssm.get_parameter(Name="/input-attendance/queue")["Parameter"][
            "Value"
        ]

        message_data = {"target_year": target_year, "target_month": target_month}
        message_body = json.dumps(message_data)

        sqs = boto3.client("sqs", region_name="ap-northeast-1")
        sqs.send_message(QueueUrl=queue_url, MessageBody=message_body)

    except Exception as e:
        print(e)
        raise e
