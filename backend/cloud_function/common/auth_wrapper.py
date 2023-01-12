from flask import Flask, make_response, Request
from typing import Any, List, Callable, Type

from common.firebase import authenticate_request_and_decode_user_id

def wrap_request_with_cors_and_auth(request: Request, allowed_methods: List[str], handler: Callable[[Type[Request], str, List[str]], Any]):
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

    # Authenticate request with Firebase
    bearer_token = request.headers.get('Authorization').split(' ').pop()
    user_id = authenticate_request_and_decode_user_id(bearer_token)


    handler(request, user_id, headers)
