from firebase_admin import firestore
from common.firebase import db

def finish_job(image_url: str, user_id: str, job_id: str):
    doc_ref = db.collection('users').document(user_id).collection('jobs').document(job_id)
    doc_ref.set({
        'url': image_url,
    })

    print(f"Finished job {job_id}")
    