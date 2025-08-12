from lambda_function import lambda_handler

mock_event = {"id": "earthquakes"}
mock_context = None  # or create a simple mock object if needed

response = lambda_handler(mock_event, mock_context)
print(response)
