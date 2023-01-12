from common.book import create_page_in_db
from common.image_generation import queue_image_generation
from flask import Flask, Request, make_response
from common.book import create_book_in_db
from uuid import UUID
from common.auth_wrapper import wrap_request_with_cors_and_auth
from random import random


def post_book(request: Request, user_id: str, headers: dict):
    
    rnd = random.Random()
    
    body = request.get_json()
    prompt = body.get('prompt')
    request_id = body.get('request_id')
    
    # Deterministic UUIDs based on request ID, for idempotency
    rnd.seed(request_id)
    book_id = UUID(rnd.getrandbits(128), version=4)
    page_id = UUID(rnd.getrandbits(128), version=4)

    book = create_book_in_db(user_id, id=book_id)
    page = create_page_in_db(user_id, id=page_id)

    queue_image_generation(prompt, id=request_id, user_id=user_id, book_id=book.id, page_id=page.id)
    
    return make_response("{}", 201, headers)


