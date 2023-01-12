from random import Random
from uuid import UUID

from common.book import create_book_in_db, create_page_in_db
from common.image_generation import queue_image_generation
from flask import Request, make_response


def post_books(request: Request, user_id: str, headers: dict):
    """
    Create a book and generate an image for its first page.
    """
    rnd = Random()

    body = request.get_json()
    prompt = body.get("prompt")
    request_id = body.get("request_id")

    # Deterministic UUIDs based on request ID, for idempotency
    rnd.seed(request_id)
    book_id = str(UUID(int=rnd.getrandbits(128), version=4))
    page_id = str(UUID(int=rnd.getrandbits(128), version=4))

    create_book_in_db(user_id, id=book_id)
    create_page_in_db(user_id, book_id=book_id, id=page_id)

    queue_image_generation(
        prompt, request_id=request_id, user_id=user_id, book_id=book_id, page_id=page_id
    )

    return make_response("{}", 201, headers)
