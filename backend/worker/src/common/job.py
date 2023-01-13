from common.firebase import db
from firebase_admin import firestore


def finish_job(image_url: str, user_id: str, book_id, page_id: str):
    page_ref = (
        db.collection("users")
        .document(user_id)
        .collection("books")
        .document(book_id)
        .collection("pages")
        .document(page_id)
    )

    page_ref.update({"imageOptions": firestore.firestore.ArrayUnion([image_url])})

    print(f"Finished job for user {user_id}, book {book_id}, page {page_id}")
