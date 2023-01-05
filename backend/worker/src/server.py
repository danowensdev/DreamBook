from common.inference import StableDiffusionInference

from google.cloud import pubsub_v1, storage
from common.config import project_id
from datetime import datetime
from common.job import finish_job

subscription_id: str = "open-job-subscription"
storage_client = storage.Client()

bucket_name = "dreambook-output-storage"

inference = StableDiffusionInference()

# TODO: Class for message payload
def handle_message(message: pubsub_v1.subscriber.message.Message) -> None:
    print(f"Received {message}.")
    
    # Put current date and time in the filename
    file_path = "dreambook-" + datetime.now().strftime("%Y%m%d-%H%M%S") + ".png"
    
    inference.run("a photo of an astronaut riding a horse on mars", output_path=file_path)

    url = upload_file_to_bucket(file_path)
    finish_job(url)

    message.ack()


def upload_file_to_bucket(file_path: str) -> str:
    bucket = storage_client.bucket(bucket_name)
    # TODO: Don't save file, upload directly from result
    blob = bucket.blob(file_path)
    blob.upload_from_filename(file_path)
  
    print(f"Uploaded {file_path} to bucket.")

    return blob.public_url
    

def check_for_messages():
  subscriber = pubsub_v1.SubscriberClient()
  subscription = subscriber.subscription_path(project_id, subscription_id)

  print(f"Listening for messages on {subscription}...")
  future = subscriber.subscribe(subscription, callback=handle_message, flow_control=pubsub_v1.types.FlowControl(max_messages=1))
  future.result() # Await on the future to block the main thread.


def main():
    print("Starting up the worker...")
    check_for_messages()

if __name__ == "__main__":
    main()
