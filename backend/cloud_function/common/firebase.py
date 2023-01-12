from firebase_admin import auth, initialize_app, firestore

firebase_app = initialize_app()
db = firestore.client()


def authenticate_request_and_decode_user_id(bearer_token: str) -> str:
    """
    Authenticate a request against Firebase Auth, using its Bearer token.
    """
    decoded_token = auth.verify_id_token(bearer_token)

    return decoded_token["uid"]
