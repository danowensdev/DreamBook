
import firebase_admin
from firebase_admin import firestore

app = firebase_admin.initialize_app()
db = firestore.client()
