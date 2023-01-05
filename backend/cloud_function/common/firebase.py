from firebase_admin import auth, initialize_app as initialize_firebase_app

firebase_app = initialize_firebase_app()

def authenticate_request_and_decode_user_id(bearer_token: str) -> str:
    decoded_token = auth.verify_id_token(bearer_token)

    return decoded_token['uid'] 
