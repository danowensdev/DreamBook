import openai
import os
openai.api_key = os.getenv('OPENAI_API_KEY')

MODEL = "text-davinci-003"
TEMPERATURE = 0.7
MAX_TOKENS = 2000
TOP_P = 1
FREQUENCY_PENALTY = 0
PRESENCE_PENALTY = 0

response = openai.Completion.create(
  model="text-davinci-003",
  prompt="Write a short, very beautiful, heartwarming children's storybook 5 pages long, with each page containing the text and the image. The image should be a complete description for prompting an image generator. Each image description should be independent, and not rely on knowledge of other images or any texts. For example:\nPage n:\nText: For as long as he could remember, Ben had loved the stars.\nImage: A young boy with golden hair and blue eyes in a bedroom, staring up at the starlit sky. Nighttime. Dreamlike, children's book.\n\n===\nPage 1:",
  temperature=TEMPERATURE,
  max_tokens=MAX_TOKENS,
  top_p=TOP_P,
  frequency_penalty=FREQUENCY_PENALTY,
  presence_penalty=PRESENCE_PENALTY
)
print(response["choices"][0]["text"])
