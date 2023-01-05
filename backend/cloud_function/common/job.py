from google.cloud import pubsub_v1
from firebase_admin import firestore
from datetime import datetime

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"

# TODO: DTO, model and type hints for jobs

db = firestore.client()

def create_job(prompt: str, id: str, user_id: str):
    create_job_in_db("", id=id, user_id=user_id)

    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_id)
    
    publisher.publish(topic_path, prompt.encode('utf-8'), user_id=user_id)
    
    print("Created job", id)



def create_job_in_db(url: str, id: str, user_id: str):
    doc_ref = db.collection('users').document(user_id).collection('jobs').document(id)
    doc_ref.set({
        'url': url,
        'status': 'pending',
        'creationDate': datetime.now
    })