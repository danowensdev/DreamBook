from flask import Flask, make_response
from google.cloud import pubsub_v1

app = Flask(__name__)

@app.route('/')
def request_handler(request):
    publisher = pubsub_v1.PublisherClient()

    project_id: str = "dreambook-713"
    topic_id: str = "open-job-topic"

    topic_path = publisher.topic_path(project_id, topic_id)

    data_str = f"Message".encode("utf-8")
    future = publisher.publish(topic_path, data_str)
    print(future.result())

    print("Published message")
    
    return make_response('Message published', 200)
