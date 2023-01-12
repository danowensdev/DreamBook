from flask import Flask, Request, make_response

from common.auth_wrapper import wrap_request_with_cors_and_auth
from common.book import create_book_in_db
from common.image_generation import queue_image_generation
from handlers.post_book import post_books

app = Flask(__name__)


@app.route("/")
def handle_post_book_request(request: Request):
    return wrap_request_with_cors_and_auth(request, ["POST"], post_books)
