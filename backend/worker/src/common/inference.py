from torch import autocast, cuda, float16
from PIL import Image
from diffusers import StableDiffusionPipeline
from common.config import get_huggingface_cli_password


class StableDiffusionInference:
    def __init__(self):
        self.device = "cuda" if cuda.is_available() else "cpu"
        torch_dtype = (
            float16  # cpu doesn't support float16; TODO: fix bug with float not working
        )

        huggingface_token = get_huggingface_cli_password()

        self.pipeline = StableDiffusionPipeline.from_pretrained(
            "runwayml/stable-diffusion-v1-5",
            torch_dtype=torch_dtype,
            device_map="auto",  # https://github.com/huggingface/diffusers/issues/968
            use_auth_token=huggingface_token,
        ).to(self.device)

    def run(self, prompt, output_path):
        print("Running inference with prompt:", prompt)
        with autocast(self.device):
            image: Image.Image = self.pipeline(prompt).images[0]
        image.save(output_path)
