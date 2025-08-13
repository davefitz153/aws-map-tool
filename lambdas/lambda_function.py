import json
import boto3
from fetch import fetch_json
from transforms import TRANSFORMS

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Datasets')

def lambda_handler(event, context):
    #dataset_id = event.get("id")
    dataset_id = event.get("pathParameters", {}).get("id")

    if not dataset_id:
        return {"statusCode": 400, "body": json.dumps({"error": "Missing dataset id"})}

    try:
        response = table.get_item(Key={"id": dataset_id})
        item = response.get("Item")
        if not item:
            return {"statusCode": 404, "body": json.dumps({"error": "Dataset not found"})}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

    url = item.get("url")
    if not url:
        return {"statusCode": 500, "body": json.dumps({"error": "URL missing in dataset record"})}

    try:
        data_json = fetch_json(url)
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": f"Failed to fetch data: {str(e)}"})}

    transform_fn = TRANSFORMS.get(dataset_id)
    if transform_fn:
        try:
            transformed = transform_fn(data_json)
        except Exception as e:
            return {"statusCode": 500, "body": json.dumps({"error": f"Transform failed: {str(e)}"})}
    else:
        transformed = data_json

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json"
        },
        "body": json.dumps(transformed)
    }
