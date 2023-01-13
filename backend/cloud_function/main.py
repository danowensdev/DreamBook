from flask import Flask, Request

from common.auth_wrapper import wrap_request_with_cors_and_auth
from handlers.post_book import post_books

app = Flask(__name__)


@app.route("/")
def handle_post_book_request(request: Request):
    return wrap_request_with_cors_and_auth(request, ["POST"], post_books)
