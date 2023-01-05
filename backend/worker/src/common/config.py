from google.cloud import secretmanager

project_id = "dreambook-713"


huggingface_pw_secret_id = "huggingface-pw"
def get_huggingface_cli_password():
    secretmanager_client = secretmanager.SecretManagerServiceClient()
    return secretmanager_client.access_secret_version(request={"name": f"projects/{project_id}/secrets/{huggingface_pw_secret_id}/versions/latest"})

    