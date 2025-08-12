import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb', region_name='us-east-1') 

table_name = 'Datasets'
table = dynamodb.Table(table_name)

datasets = [
    {
        'id': 'earthquakes',
        'category': 'geology',
        'source': 'api',
        'name': "USGS Earthquakes (Past Day)",
        'url': "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson",
        'cache': True
    },
]

def seed_data():
    for item in datasets:
        try:
            print(f"Inserting item with id: {item['id']} and category: {item['category']}")
            table.put_item(Item=item)
        except ClientError as e:
            print(f"Failed to insert {item['id']}: {e.response['Error']['Message']}")

if __name__ == '__main__':
    seed_data()
