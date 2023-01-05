# TODO: Refactor into separate modules

print("Starting up the worker...")
import io
from torch import autocast, float16, cuda
from diffusers import StableDiffusionPipeline
from google.cloud import pubsub_v1, secretmanager, storage
from datetime import datetime

import firebase_admin
from firebase_admin import firestore

app = firebase_admin.initialize_app()
db = firestore.client()

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"
subscription_id: str = "open-job-subscription"
bucket_name = "TODO"

huggingface_pw_secret_id = "huggingface-pw"

secretmanager_client = secretmanager.SecretManagerServiceClient()
storage_client = storage.Client()

huggingface_token = secretmanager_client.access_secret_version(request={"name": f"projects/{project_id}/secrets/{huggingface_pw_secret_id}/versions/latest"})
#assert cuda.is_available()

def handle_message(message: pubsub_v1.subscriber.message.Message) -> None:
    print(f"Received {message}.")
    # Put current date and time in the filename

    file_path = "dreambook-" + datetime.now().strftime("%Y%m%d-%H%M%S") + ".png"
    run_inference("a photo of an astronaut riding a horse on mars", file_path)

    url = upload_file_to_bucket(file_path)
    save_url_to_firestore(url)

    message.ack()


def upload_file_to_bucket(file_path: str) -> str:
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_path)
    blob.upload_from_filename(file_path)
  
    print(f"Uploaded {file_path} to bucket.")

    return blob.public_url
    

def save_url_to_firestore(url: str, user_id: str, job_id: str):
    doc_ref = db.collection('users').document(user_id).collection('dreams').document(job_id)
    doc_ref.set({
        'url': url
    })

    print(f"Saved {url} to Firestore.")
    


def check_for_messages():
  subscriber = pubsub_v1.SubscriberClient()
  subscription = subscriber.subscription_path(project_id, subscription_id)

  print(f"Listening for messages on {subscription}...\n")
  subscriber.subscribe(subscription, callback=handle_message, flow_control=pubsub_v1.types.FlowControl(max_messages=1))

check_for_messages()

pipe = StableDiffusionPipeline.from_pretrained(
    "runwayml/stable-diffusion-v1-5",
    torch_dtype=float16,
    device_map="auto", # https://github.com/huggingface/diffusers/issues/968
    use_auth_token=huggingface_token
).to("cuda")


def run_inference(prompt):
    print("Running inference with prompt:", prompt)
    with autocast("cuda"):
      image = pipe(prompt).images[0]
    img_data = io.BytesIO()
    image.save(img_data, format="PNG")
    img_data.seek(0)
    return img_data

