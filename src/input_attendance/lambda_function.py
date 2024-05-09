import boto3
import base64
import os
import time
import json


def lambda_handler(event, context):
    ec2 = boto3.client("ec2", region_name="ap-northeast-1")
    instance_id = None

    try:
        message_body = json.loads(event["Records"][0]["body"])
        target_year = message_body["target_year"]
        target_month = message_body["target_month"]

        dir_path = os.path.dirname(os.path.realpath(__file__))
        script_path = os.path.join(dir_path, "script.sh")

        with open(script_path, "r") as file:
            user_data_script = file.read()

        user_data_script += f"\nsudo docker run --rm --name input-attendance-container -it -d input-attendance-image sh -c 'python3 -m inputattendance {target_year} {target_month}'"

        user_data_encoded = base64.b64encode(user_data_script.encode("utf-8")).decode(
            "utf-8"
        )

        ec2_response = ec2.run_instances(
            ImageId="ami-0d48337b7d3c86f62",
            InstanceType="t3.micro",
            MinCount=1,
            MaxCount=1,
            KeyName="input-attendance",
            SecurityGroupIds=["sg-066dcdb834b0607df"],
            IamInstanceProfile={"Name": "input-attendance-ec2-role"},
            UserData=user_data_encoded,
        )

        instance_id = ec2_response["Instances"][0]["InstanceId"]
        print("Start instance", instance_id)

        # userdataの場合、コマンド完了の検知が複雑なため採用しない、その代わり十分な時間待機する
        time.sleep(300)

    except Exception as e:
        print(e)

        raise e

    finally:
        if instance_id:
            print(f"Termination instance: {instance_id}")
            ec2.terminate_instances(InstanceIds=[instance_id])
