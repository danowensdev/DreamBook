from flask import Request
from typing import Any, List, Callable, Type

from common.firebase import authenticate_request_and_decode_user_id


def wrap_request_with_cors_and_auth(
    request: Request,
    allowed_methods: List[str],
    handler: Callable[[Type[Request], str, List[str]], Any],
):
    """
    Wraps a request handler with CORS for the HTTP methods specified with `allowed_methods`,
    and decodes the user ID from the Authorization Bearer Token. If not present, fails the request.
    """
    if request.method == "OPTIONS":
        headers = {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": ", ".join(allowed_methods),
            "Access-Control-Allow-Headers": "Content-Type, Authorization",
            "Access-Control-Max-Age": "3600",
        }
        return ("", 204, headers)

    headers = {"Access-Control-Allow-Origin": "*"}

    # Authenticate request with Firebase
    bearer_token = request.headers.get("Authorization").split(" ").pop()
    user_id = authenticate_request_and_decode_user_id(bearer_token)

    return handler(request, user_id, headers)
