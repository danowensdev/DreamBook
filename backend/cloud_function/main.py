from flask import Flask, make_response, Request
from google.cloud import pubsub_v1
from firebase_admin import auth, initialize_app as initialize_firebase_app

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"

app = initialize_firebase_app()

app = Flask(__name__)

def authenticate_request_and_decode_user_id(request: Request) -> str:
    id_token = request.headers.get('Authorization').split(' ').pop()
    decoded_token = auth.verify_id_token(id_token)

    return decoded_token['uid'] 


@app.route('/')
def request_handler(request: Request):
    # TODO: Extract CORS handling to wrapper

    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    headers = {
        'Access-Control-Allow-Origin': '*'
    }

    user_id = authenticate_request_and_decode_user_id(request)
    print("User ID: ", user_id)

    prompt = request.get_json().get('prompt')

    publisher = pubsub_v1.PublisherClient()

    topic_path = publisher.topic_path(project_id, topic_id)

    future = publisher.publish(topic_path, prompt, user_id=user_id)

    print("Published message")
    
    return make_response('Message published', 200, headers)
