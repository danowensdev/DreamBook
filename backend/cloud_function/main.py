from flask import Flask, make_response, Request
from common.job import create_job
from common.firebase import authenticate_request_and_decode_user_id

app = Flask(__name__)

@app.route('/')
def request_handler(request: Request):
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

    bearer_token = request.headers.get('Authorization').split(' ').pop()
    user_id = authenticate_request_and_decode_user_id(bearer_token)
    print("User ID: ", user_id)

    body = request.get_json()
    prompt = body.get('prompt')
    request_id = body.get('request_id')

    create_job(prompt, id=request_id, user_id=user_id)
    
    return make_response("{}", 200, headers)
