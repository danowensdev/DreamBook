from flask import Flask, make_response
from google.cloud import pubsub_v1

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"

app = Flask(__name__)

@app.route('/')
def request_handler(request):
    # TODO: Extract CORS handling to wrapper

    # Set CORS headers for the preflight request
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '3600'
        }

        return ('', 204, headers)

    # Set CORS headers for the main request
    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    publisher = pubsub_v1.PublisherClient()


    topic_path = publisher.topic_path(project_id, topic_id)

    data_str = f"Message".encode("utf-8")
    future = publisher.publish(topic_path, data_str)
    print(future.result())

    print("Published message")
    
    return make_response('Message published', 200, headers)
