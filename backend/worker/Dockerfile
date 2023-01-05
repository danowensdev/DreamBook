FROM frolvlad/alpine-miniconda3
RUN apk --no-cache add git  
RUN git clone https://github.com/CompVis/stable-diffusion.git

COPY "environment.yml" "stable-diffusion/environment.yaml"

RUN cd stable-diffusion && conda env create -f environment.yaml

COPY "src" "./src"

ENTRYPOINT ["conda" ,"run", "--no-capture-output", "-n", "ldm", "python3", "./src/server.py"]