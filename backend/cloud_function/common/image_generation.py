from google.cloud import pubsub_v1

project_id: str = "dreambook-713"
topic_id: str = "open-job-topic"


def queue_image_generation(
    prompt: str, request_id: str, user_id: str, book_id: str, page_id: str
):
    """
    Schedule a job to generate an image for the given prompt, to be stored
    as an image option for the given user, book, and page.
    """
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_id)

    publisher.publish(
        topic_path,
        prompt.encode("utf-8"),
        request_id=request_id,
        user_id=user_id,
        book_id=book_id,
        page_id=page_id,
    )

    print("Enqueued image generation for prompt: " + prompt)


def build_image_prompt_from_description(description: str):
    return f"Beautiful artistic children's story book illustration. {description}"
