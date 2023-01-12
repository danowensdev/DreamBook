from datetime import datetime
from common.firebase import db

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"

# TODO: DTO class, model and type hints for books


def create_book_in_db(user_id: str, id: str):
    book_doc_ref = (
        db.collection("users")
        .document(user_id)
        .collection("books")
        .document(id)
        .set({"creationDate": datetime.now()})
    )
    return book_doc_ref


def create_page_in_db(user_id: str, book_id: str, id: str):
    page_doc_ref = (
        db.collection("users")
        .document(user_id)
        .collection("books")
        .document(book_id)
        .collection("pages")
        .document(id)
        .set({"creationDate": datetime.now(), "imageOptions": [], "status": "pending"})
    )
    return page_doc_ref
