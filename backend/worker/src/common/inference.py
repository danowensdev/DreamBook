import io
from torch import autocast, float16, float, cuda
from diffusers import StableDiffusionPipeline
from common.config import get_huggingface_cli_password

class StableDiffusionInference():
    def __init__(self):
        self.device = "cuda" if cuda.is_available() else "cpu"
        torch_dtype = float16 if self.device == "cuda" else float # cpu doesn't support float16; TODO: fix bug with float not working

        huggingface_token = get_huggingface_cli_password()

        self.pipeline = StableDiffusionPipeline.from_pretrained(
            "runwayml/stable-diffusion-v1-5",
            torch_dtype=torch_dtype,
            device_map="auto", # https://github.com/huggingface/diffusers/issues/968
            use_auth_token=huggingface_token
        ).to(self.device)

    def run(self, prompt, output_path):
        print("Running inference with prompt:", prompt)
        with autocast(self.device):
            image = self.pipeline(prompt).images[0]

        img_data = io.BytesIO()
        image.save(img_data, format="PNG")
        img_data.seek(0)
        return img_data
