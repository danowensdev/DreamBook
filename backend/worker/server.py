print("Starting up the worker...")
import io
from torch import autocast, float16, cuda
from diffusers import StableDiffusionPipeline
from google.cloud import pubsub_v1, secretmanager

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"
subscription_id: str = "open-job-subscription"

huggingface_pw_secret_id = "huggingface-pw"

secretmanager_client = secretmanager.SecretManagerServiceClient()
huggingface_token = secretmanager_client.access_secret_version(request={"name": f"projects/{project_id}/secrets/{huggingface_pw_secret_id}/versions/latest"})
#assert cuda.is_available()

def handle_message(message: pubsub_v1.subscriber.message.Message) -> None:
    print(f"Received {message}.")
    run_inference("a photo of an astronaut riding a horse on mars")

    message.ack()


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

